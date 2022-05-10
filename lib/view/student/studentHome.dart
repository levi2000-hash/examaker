import 'package:examaker/locationView.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:flutter/material.dart';

import '../exam/examenPage.dart';

class StudentHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welkom ${appData.loggedInStudent!.name}"),
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: SizedBox(
              height: 100,
              child: Card(
                borderOnForeground: true,
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
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ExamenPage()))
                    },
                    child: const Text("Start"),
                  ),
                  ElevatedButton(
                    child: const Text("Locatie demo"),
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LocationView()))
                    },
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}
