import 'package:flutter/material.dart';
import 'package:google_maps_implement/places.dart';
import 'package:google_maps_implement/widgetClass/mapWidget.dart';
import 'package:google_maps_implement/widgetClass/searchBar.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google_Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //good
      home: Places(title: 'Geolocation'),
      //home: GoogleApi(),
      //home: GoogleMapping(),
      //searbarfloating
      //home: BarSearch(),
    );
  }
}
