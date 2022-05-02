import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final bool _completed = false;
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