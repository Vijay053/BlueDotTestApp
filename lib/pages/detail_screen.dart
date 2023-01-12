import 'package:blue_dot_test_app/models/places.dart';
import 'package:blue_dot_test_app/services/web_apis.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);
  static const String routeName = '/detailScreen';

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late PageController _controller;
  Place? placeSummary;
  Place? place;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    Future.delayed(Duration.zero, () async {
      place = await WebApiService().getPlaceDetailsById(placeSummary!.placeId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    placeSummary = ModalRoute.of(context)!.settings.arguments as Place;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          placeSummary!.name,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: place == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  Text('Loading...')
                ],
              ),
            )
          : Column(
              children: [
                Flexible(
                  flex: 1,
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        disableGestures: true,
                        imageProvider: Image.network(
                          place!.photos[index].photoUrl,
                          fit: BoxFit.fitHeight,
                        ).image,
                        heroAttributes: PhotoViewHeroAttributes(
                          tag: place!.photos[index].photoUrl,
                        ),
                      );
                    },
                    backgroundDecoration:
                        const BoxDecoration(color: Color(0xffF2F2F2)),
                    itemCount: place!.photos.length,
                    loadingBuilder: (context, event) => Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          value: event == null
                              ? 0
                              : event.cumulativeBytesLoaded /
                                  event.expectedTotalBytes!,
                        ),
                      ),
                    ),
                    onPageChanged: (value) {},
                    pageController: _controller,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        place!.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(place!.vicinity),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
