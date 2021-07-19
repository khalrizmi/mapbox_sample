import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_example/Constant.dart';
import 'package:mapbox_example/example_page.dart';
import 'package:mapbox_example/fancy_fab.dart';
import 'package:mapbox_example/location_helper.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';

class FullMapPage extends ExamplePage {
  FullMapPage() : super(const Icon(Icons.map), 'Full screen map');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMapController? mapController;
  bool isBusy = true;
  late Position myPosition;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();

    getCurrentLocation();
  }

  Future<Position> getCurrentLocation() async {
    setState(() {
      isBusy = true;
    });

    myPosition = await LocationHelper().determinePosition();

    setState(() {
      isBusy = false;
    });
    return myPosition;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: floatingActionButton(),
        // floatingActionButton: FancyFabSecond(),
        body: isBusy
            ? Center(child: CircularProgressIndicator())
            : MapboxMap(
                accessToken: Constant.ACCESS_TOKEN,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                    target: LatLng(myPosition.latitude, myPosition.longitude),
                    zoom: 15,),
                onMapClick: onMapClick,
                onStyleLoadedCallback: onStyleLoadedCallback,
              ));
  }

  void onStyleLoadedCallback() {}

  void onMapClick(Point<double> point, LatLng latLng) {

  }

  Widget floatingActionButton() {
    return FancyFab(onLinePressed: () {}, onPolyPressed: () {});
  }
}
