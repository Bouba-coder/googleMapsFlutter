import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'package:google_maps_implement/logicClass/placesList.dart';
import 'package:google_maps_implement/places.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'mapWidget.dart';

class BarSearch extends StatefulWidget {
  @override
  _BarSearchState createState() => _BarSearchState();
}

class _BarSearchState extends State<BarSearch> {

  //list
  var places = new PlacesList();
  var _controller = FloatingSearchBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          //buildMap(),
          //GoogleMapping(),
          //floatGood
          //buildFloatingSearchBar(),
          //mine
          //searchBarWidget(),
        ],
      ),
    );
  }

  //test
  /*
  Widget searchBarWidget(){
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: "Search your address",
      openAxisAlignment: 0.0,
      maxWidth:  600,
      axisAlignment: isPortrait ? 0.0 : -1.0,
      scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
      elevation: 4.0,
      onQueryChanged: (query){
        //calling data methods
      },
      //showDrawerHamburger: false,
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 500),
      transition: CircularFloatingSearchBarTransition(),
      debounceDelay: Duration(milliseconds: 500),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
              onPressed: (){
              print('places Pressed');
              }),
        ),

        //clearing search
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,

        )
      ],

      //builder
      builder: (context, transition){
        return ClipRRect(
          child: Material(
            color: Colors.white,
            child: Container(
              height: 200.0,
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Home'),
                    subtitle: Text('more info'),
                  ),
                ],
              ),
            ),
          ),
        );
      },

    );
  }
*/

  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: 'Search...',
      controller: _controller,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
        places.getSuggestion(query);
        //_controller.query = places.placeList[0]["description"].toString();
        //places.placeList[0]["description"].toString();
        
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return  ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: places.placeList.length,
                itemBuilder: (context, index) {
                  //_controller.query = places.placeList[index]["description"];
                  return ListTile(
                      title: Container(child: Text(places.placeList[index]["description"])),
                  );
                }
        );
      },
    );
  }
}

buildMap(){
}
