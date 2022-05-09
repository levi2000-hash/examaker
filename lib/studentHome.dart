import 'package:examaker/locationView.dart';
import 'package:flutter/material.dart';

import 'examenPage.dart';

class StudentHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Student dashboard"),
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Row(children: [
            Expanded(
                child: Center(
                    child: Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: const Text(
                "Intro Mobile (2u)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ))),
            TextButton(
                onPressed: () => {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => ExamenPage()))
                    },
                child: const Text("Start"),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: Colors.amber,
                )),
            ElevatedButton(
              child: const Text("Locatie demo"),
              onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LocationView()))
              },
            )
          ]),
        ));
  }
}
