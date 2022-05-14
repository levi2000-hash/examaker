import 'package:examaker/locationView.dart';
import 'package:examaker/services/exam_service.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:examaker/view/widgets/loading_screen.dart';
import 'package:flutter/material.dart';

import '../../model/examen.dart';
import '../exam/examenPage.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  ExamService examService = ExamService();
  Examen? examen;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    examService.getExamen().then((value) {
      setState(() {
        examen = value;
        appData.currentExam = examen;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welkom ${appData.loggedInStudent!.name}"),
        ),
        body: _isLoading
            ? LoadingScreen.showLoading()
            : Container(
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
                          child: Text(
                            examen!.naam,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))),
                        ElevatedButton(
                          onPressed: () => {
                            //TODO: Check of er nog een poging is
                            if (false)
                              {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                              "Examen niet beschikbaar"),
                                          content: const Text("Tijd verlopen"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop("dialog");
                                                },
                                                child: const Text("Ok"))
                                          ],
                                        ))
                              }
                            else
                              {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => ExamenPage()))
                              }
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
