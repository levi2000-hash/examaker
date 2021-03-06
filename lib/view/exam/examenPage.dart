import 'dart:convert';
import 'dart:developer';

import 'package:examaker/view/student/studentHome.dart';
import 'package:examaker/view/widgets/loading_screen.dart';
import 'package:http/http.dart' as http;
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

  Examen examen = appData.currentExam!;
  List<vraagWidget> vraagWidgets = [];
  ExamenMomentService service = ExamenMomentService();
  Uuid uuid = Uuid();

  bool _isLoading = true;
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
    super.initState();
    _getCurrentLocation();
    //_isLoading = false;
    WidgetsBinding.instance?.addObserver(this);
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
        body: _isLoading
            ? LoadingScreen.showLoading("Locatie bepalen...")
            : SingleChildScrollView(
                child: Form(
                    key: examKey,
                    child: Column(
                      children: [
                        ExamTimer(appData.currentExam!.duur * 60),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: vraagWidgets,
                          ),
                        ),
                      ],
                    ))),
        floatingActionButton: _isLoading
            ? null
            : FloatingActionButton(
                child: const Icon(Icons.check),
                splashColor: Colors.red,
                hoverElevation: 50,
                tooltip: "Dien in",
                foregroundColor: Colors.white,
                onPressed: () => turnIn(examen)));
  }

  turnIn(Examen examen) {
    ExamenMoment examenMoment = ExamenMoment(
        uuid.v4(),
        appData.loggedInStudent!.studentNumberToId(),
        examen.id!,
        _currentPosition!.longitude,
        _currentPosition!.latitude,
        _currentAddress,
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
    examenMoment.finished = true;
    service.addExamenMoment(examenMoment).then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => const StudentHome())));
  }

  void _getCurrentLocation() async {
    _getLocationPermission().then((permission) {
      if (permission) {
        log("Got permission");
        Geolocator.getCurrentPosition(
                forceAndroidLocationManager: true,
                desiredAccuracy: LocationAccuracy.low)
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
              _currentPosition = position;
              _isLoading = false;
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
