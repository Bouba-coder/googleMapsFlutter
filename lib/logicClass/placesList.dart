import 'dart:convert';

import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class PlacesList{
  //attribut
  var uuid = new Uuid();
  String _sessionToken;
  List<dynamic> placeList = [];

  //method
//api call
  void getSuggestion(String input) async {
    final client = Client();
    String PLACES_API_KEY = "AIzaSyBKKc8CuRH_wZG7xBXZhvkpo_oRMzMMRp0";
    //String type = '(regions)';
    String baseURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken&language=fr';
    //getting data

    var response = await client.get(request);
    //print(response.headers);
    //print(response.body);
    if (response.statusCode == 200) {
        placeList = json.decode(response.body)['predictions'];
        //placeList = json.decode(response.body)[1]['description'];
        //placeList = json.decode(response.body)['predictions']["description"];
        print("texte : $placeList");
    } else {
      throw Exception('Failed to load predictions');
    }
  }


}