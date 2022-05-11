import 'dart:developer';

import 'package:examaker/model/examen.dart';
import 'package:examaker/model/vraag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class ExamenPage extends StatefulWidget {
  @override
  State<ExamenPage> createState() => _ExamenPageState();

  final List<Vraag> examenVragen;
  ExamenPage(this.examenVragen, {Key? key}) : super(key: key) {
    final examenVragen = this.examenVragen;
  }
}

class _ExamenPageState extends State<ExamenPage> with WidgetsBindingObserver {
  late AppLifecycleState appState;
  final bool isComplete = false;

  int outOfFocusCount = 0;

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
        title: const Text("Examen Java"),
      ),
      body: Column(children: [
        //Vraag 1
        examenVragen.forEach((vraag) => {vraag.build(context)})
      ]),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.check),
      ),
    );
  }
}
