import 'dart:convert';
import 'dart:developer';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  Position? _currentPosition;
  String _currentAddress = "Getting location";

  MapController mapController =
      MapController(initMapWithUserPosition: true, initPosition: null);

  Future<bool> _getLocationPermission() async {
    return Geolocator.checkPermission().then((LocationPermission result) {
      if (result == LocationPermission.denied ||
          result == LocationPermission.deniedForever) {
        return Geolocator.requestPermission().then((value) {
          return (value != LocationPermission.denied &&
              value != LocationPermission.deniedForever);
        });
      } else {
        return true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Locatie"),
          centerTitle: true,
        ),
        body: Container(
            child: Column(
          children: [
            Text(_currentAddress),
            Flexible(
              child: OSMFlutter(
                  controller: mapController,
                  initZoom: 16,
                  userLocationMarker: UserLocationMaker(
                      personMarker: const MarkerIcon(
                        icon: Icon(Icons.location_history_rounded,
                            color: Colors.red, size: 48),
                      ),
                      directionArrowMarker: const MarkerIcon(
                        icon: Icon(Icons.double_arrow, size: 48),
                      ))),
            )
          ],
        )));
  }
}
