import 'dart:developer';

import 'package:examaker/model/examen.dart';
import 'package:examaker/model/vraag.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:flutter/cupertino.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: Text(appData.currentExam!.naam),
        ),
        body: Column(
          children: [
            Vraag.code("Hoe benoem je een variabele in dart", 2).build(context),
            Vraag.multipleChoice(
                    "Kies de juiste manier om een final variabele te maken",
                    ["final", "public", "var"],
                    "final",
                    5)
                .build(context),
            Vraag.open("Hoe noemt de taal van flutter", "dart", 2)
                .build(context)
          ],
        ));
  }
}
