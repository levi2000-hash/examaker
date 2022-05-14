// ignore_for_file: unnecessary_const

import 'package:examaker/model/examen.dart';
import 'package:examaker/services/exam_service.dart';
import 'package:examaker/view/exam/createExam.dart';
import 'package:examaker/view/widgets/loading_screen.dart';
import 'package:flutter/material.dart';

class ExamenOverview extends StatefulWidget {
  const ExamenOverview({Key? key}) : super(key: key);
  @override
  State<ExamenOverview> createState() => _ExamenOverviewState();
}

class _ExamenOverviewState extends State<ExamenOverview> {
  Examen? examen;
  bool _isLoading = true;
  ExamService examService = ExamService();

  @override
  void initState() {
    super.initState();
    examService.getExamen().then((value) {
      setState(() {
        examen = value;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Examens"),
        centerTitle: true,
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
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          examen!.naam,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ElevatedButton(
                                  onPressed: null, child: Text("Bewerken")),
                            ),
                            ElevatedButton(
                                onPressed: null, child: Text("Verwijderen"))
                          ],
                        ),
                      ],
                    )),
                  ),
                ),
              ))),
    );
  }
}
