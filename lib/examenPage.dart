import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class ExamenPage extends StatefulWidget {
  const ExamenPage({Key? key}) : super(key: key);

  @override
  State<ExamenPage> createState() => _ExamenPageState();
}

class _ExamenPageState extends State<ExamenPage> with WidgetsBindingObserver {
  final bool _completed = false;
  late AppLifecycleState appState;
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
        OpenExamenVraag("vraag 1"),
        OpenExamenVraag("Vraag 2")
      ]),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.check),
      ),
    );
  }
}
