import 'package:blue_dot_test_app/models/places.dart';
import 'package:blue_dot_test_app/pages/detail_screen.dart';
import 'package:flutter/material.dart';

class CustomInfoWidget extends StatelessWidget {
  const CustomInfoWidget(this.place, {Key? key}) : super(key: key);
  final Place place;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DetailScreen.routeName, arguments: place);
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 150,
                        child: Image.network(
                          place.photos.first.photoThumbUrl,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: Column(
                        children: [
                          Text(
                            place.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Flexible(
                            child: Text(
                              place.vicinity,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
