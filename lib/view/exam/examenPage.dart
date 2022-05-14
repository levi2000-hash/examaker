import 'dart:developer';

import 'package:examaker/model/examen.dart';
import 'package:examaker/model/vraag.dart';
import 'package:examaker/services/exam_timer.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:flutter/material.dart';

class ExamenPage extends StatefulWidget {
  const ExamenPage({Key? key}) : super(key: key);
  @override
  State<ExamenPage> createState() => _ExamenPageState();
}

class _ExamenPageState extends State<ExamenPage> with WidgetsBindingObserver {
  late AppLifecycleState appState;
  final bool isComplete = false;

  Examen examen = AppData().currentExam!;

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
                    children: examen.vragen.map((vraag) {
                      return vraag.build(context);
                    }).toList(),
                  ),
                ],
              ))),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          hoverColor: Colors.green[200],
          highlightElevation: 50,
          splashColor: Colors.red,
          hoverElevation: 50,
          tooltip: "Dien in",
          foregroundColor: Colors.white,
          onPressed: turnIn(examen)),
    );
  }

  turnIn(Examen examen) {
    //TODO: valideer examen en stuur deze naar firebase
  }
}
