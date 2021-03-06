import 'dart:developer';
import 'package:flutter/material.dart';
//import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_implement/logicClass/geocodingGoogleMap.dart';
import 'package:google_maps_implement/widgetClass/mapWidget.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Places extends StatefulWidget {
  Places({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PlacesState createState() => _PlacesState();
}

class _PlacesState extends State<Places> {


  var _controller = TextEditingController();
  var uuid = new Uuid();
  String _sessionToken;
  List<dynamic> _placeList = [];
  String _address = "";
  Marker marque;
  LatLng tappedPointLatLng = LatLng(12.24444, 48.200000);
  double latitude = 42.88548214161018;
  double longitude = 2.88548214161018;


  //geocoding
  //var googleGeocoding = new GoogleGeocoding("AIzaSyBKKc8CuRH_wZG7xBXZhvkpo_oRMzMMRp0");
  getAddress() async {
    //var result = await googleGeocoding.geocoding.getReverse(LatLon(8.88548214161018, 2.361399047076702));
    //print("${result.results.first}");
  }


  //list for adding marquers
  List<Marker> myMarker = [];

  //add marker method
  _addMarker(LatLng tappedPoint){
    print(tappedPoint);
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
        )
      );
    }
    );
    tappedPointLatLng = tappedPoint;
    geocode.longitudeCoordi = tappedPointLatLng.longitude;
    geocode.latitudeCoordi = tappedPointLatLng.latitude;
    _controller.text = geocode.address;
  }


  //calling geocode object
  GeocodingGoogleMapping geocode = new GeocodingGoogleMapping();
  //calling map...
  GoogleMapController mapController;
  //final LatLng _center = const LatLng(45.521563, -122.677433);
  CameraPosition _initialPosition = CameraPosition(target: LatLng(48.8854716, 2.3612719), zoom: 20.0);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }



  @override
  //init to subscribe and listen to _controller
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  //void latlin test geetting latlng(il faudra probablement l'enlever)
  void getLatLng() async {
    //getting lat lng
    double screenWidht = MediaQuery.of(context).size.width*MediaQuery.of(context).devicePixelRatio;
    double screenHeight = MediaQuery.of(context).size.height*MediaQuery.of(context).devicePixelRatio;

    double middleX = screenWidht / 2;
    double middleY = screenHeight / 2;

    ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());
    LatLng middlePoint = await mapController.getLatLng(screenCoordinate);
    print("the midle point : $middlePoint");
  }
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
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
        print("texte : $_placeList");
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    geocode.fetchSuggestions(_controller.text);
    geocode.fetchAddress(tappedPointLatLng.latitude, tappedPointLatLng.longitude);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        //padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 0.0),
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _initialPosition,
                onTap: _addMarker,
                markers: {
                  //Set.from(myMarker)
                  Marker(
                    markerId: MarkerId('current'),
                      position: LatLng(geocode.latitudeCoordi, geocode.longitudeCoordi),
                  infoWindow: InfoWindow(title: _controller.text)
                  )
              },
              ),

              Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Enter your address",
                        focusColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: Icon(Icons.map),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel), onPressed: (){_controller.clear();},
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _placeList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_placeList[index]["description"]),
                        onTap: (){
                          setState(() {
                            //_address = _placeList[index]["description"].toString();
                            if(_placeList.isEmpty){
                              _address = _controller.text;
                            }else {
                              _controller.text = _placeList[index]["description"].toString();
                              _placeList.clear();
                              //_address = _controller.text;
                            }
                            mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(geocode.latitudeCoordi, geocode.longitudeCoordi), zoom: 18.0)));
                            //print("${mapController.getLatLng(ScreenCoordinate(x: latLocation, y: lngLocation))}");
                            //getLatLng();

                          });

                        },
                      );
                    },
                  )
                ],
              ),
              _buildContainer(),





              /*Text("Address : $_address "),
              Text("Address to Coordinate(Latitude and longitude) ${geocode.latitudeCoordi} : ${geocode.longitudeCoordi}"),
              TextButton.icon(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoogleMapping()),
                );
              }, icon: Icon(Icons.place), label: Text("Map")),*/

            ],
          ),
    );
  }

  _buildContainer(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(vertical: 10.5, horizontal: 10.5),
        height: 70.5,
        width: 260.5,
        decoration: new BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10.1),
        ),
        //child: Text("${tappedPointLatLng.latitude}, ${tappedPointLatLng.longitude}"),
        child: Text("${tappedPointLatLng}, ${geocode.address}", style: TextStyle(color: Colors.white, fontSize: 14.1),),
      ),
    );
  }
}