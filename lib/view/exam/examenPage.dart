import 'dart:developer';

import 'package:examaker/model/examen.dart';
import 'package:examaker/model/examenMoment.dart';
import 'package:examaker/model/vraag.dart';
import 'package:examaker/services/exam_moment_service.dart';
import 'package:examaker/services/exam_timer.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ExamenPage extends StatefulWidget {
  const ExamenPage({Key? key}) : super(key: key);
  @override
  State<ExamenPage> createState() => _ExamenPageState();
}

class _ExamenPageState extends State<ExamenPage> with WidgetsBindingObserver {
  late AppLifecycleState appState;
  final bool isComplete = false;

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
    //TODO: valideer examen en stuur deze naar firebase
    // vragen.forEach((vraag) {
    //   log(vraag.answerController.text);
    // });

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

    for (var antw in antwoorden) {
      log(antw["vraag"]!);
      log(antw["antwoord"]!);
    }

    //service.addExamenMoment(examenMoment);
  }
}
