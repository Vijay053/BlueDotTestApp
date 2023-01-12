import 'package:blue_dot_test_app/pages/home_page.dart';
import 'package:blue_dot_test_app/services/location_service.dart';
import 'package:blue_dot_test_app/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  Log.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocationService>(
          create: (context) => LocationService(),
        ),
      ],
      child: MaterialApp(
        title: 'BlueDotSampleApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(10.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 2, color: Colors.black26),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1, color: Colors.black26),
            ),
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
            labelStyle: const TextStyle(color: Colors.green),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
