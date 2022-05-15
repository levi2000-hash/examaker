import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:examaker/locationView.dart';
import 'package:examaker/model/examen.dart';
import 'package:examaker/model/examenMoment.dart';
import 'package:examaker/model/vraag.dart';
import 'package:examaker/services/exam_moment_service.dart';
import 'package:examaker/services/exam_timer.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class ExamenPage extends StatefulWidget {
  const ExamenPage({Key? key}) : super(key: key);
  @override
  State<ExamenPage> createState() => _ExamenPageState();
}

class _ExamenPageState extends State<ExamenPage> with WidgetsBindingObserver {
  late AppLifecycleState appState;
  final bool isComplete = false;
  Position? _currentPosition;
  String _currentAddress = "Getting location";
  MapController mapController =
      MapController(initMapWithUserPosition: true, initPosition: null);
  Examen examen = AppData().currentExam!;
  List<vraagWidget> vraagWidgets = [];
  ExamenMomentService service = ExamenMomentService();
  Uuid uuid = Uuid();

  int outOfFocusCount = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      appState = state;
    });

    if (appState == AppLifecycleState.paused) {
      outOfFocusCount += 1;
    }
  }

  @override
  void initState() {
    () => _getCurrentLocation();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    for (var vraag in examen.vragen) {
      log(vraag.vraag);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examKey = GlobalKey<FormState>();
    vraagWidgets = examen.vragen.map((vraag) {
      return vraagWidget(
        vraag: vraag,
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(appData.currentExam!.naam),
      ),
      body: SingleChildScrollView(
          child: Form(
              key: examKey,
              child: Column(
                children: [
                  ExamTimer(4200),
                  Column(
                    children: vraagWidgets,
                  ),
                ],
              ))),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          splashColor: Colors.red,
          hoverElevation: 50,
          tooltip: "Dien in",
          foregroundColor: Colors.white,
          onPressed: () => turnIn(examen)),
    );
  }

  turnIn(Examen examen) {
    ExamenMoment examenMoment = ExamenMoment(
        uuid.v4(),
        appData.loggedInStudent!.studentNumberToId(),
        examen.id!,
        1,
        1,
        "Adres",
        outOfFocusCount);

    List<Map<String, String>> antwoorden = [];
    for (var vraagWidget in vraagWidgets) {
      var antwoord;
      if (vraagWidget.vraag.vraagSoort == VraagSoort.multipleChoice) {
        antwoord = {
          "vraag": vraagWidget.vraag.vraag,
          "antwoord": vraagWidget.keuze!
        };
      } else {
        antwoord = {
          "vraag": vraagWidget.vraag.vraag,
          "antwoord": vraagWidget.answerController.text
        };
      }
      antwoorden.add(antwoord);
    }

    examenMoment.antwoorden = antwoorden;
    examenMoment.lat = _currentPosition!.latitude;
    examenMoment.lon = _currentPosition!.longitude;
    examenMoment.adres = _currentAddress;
    examenMoment.outOfFocusCount = outOfFocusCount;
    examenMoment.finished = true;
    service.addExamenMoment(examenMoment);
  }

  void _getCurrentLocation() async {
    _getLocationPermission().then((permission) {
      if (permission) {
        log("Got permission");
        Geolocator.getCurrentPosition(
                forceAndroidLocationManager: true,
                desiredAccuracy: LocationAccuracy.best)
            .then((position) {
          http
              .get(Uri.parse(
                  "https://nominatim.openstreetmap.org/reverse?format=json&lat=" +
                      position.latitude.toString() +
                      "&lon=" +
                      position.longitude.toString()))
              .then((address) {
            Map<String, dynamic> json = jsonDecode(address.body);

            setState(() {
              _currentAddress = json["display_name"];
              mapController.changeLocation(GeoPoint(
                  latitude: position.latitude, longitude: position.longitude));
            });
          });
        });
      } else {
        log("No permission");
      }
    });
  }

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
}
