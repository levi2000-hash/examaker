import 'dart:developer';

import 'package:examaker/model/examen.dart';
import 'package:examaker/model/examenMoment.dart';
import 'package:examaker/model/student.dart';
import 'package:examaker/services/exam_moment_service.dart';
import 'package:examaker/services/exam_service.dart';
import 'package:examaker/services/student_service.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:examaker/view/admin/admin_result_detail.dart';
import 'package:examaker/view/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  ExamenMomentService examenMomentService = ExamenMomentService();
  StudentService studentService = StudentService();
  ExamService examService = ExamService();
  Examen? examen;
  List<ExamenMoment> momenten = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    examService.getExamen().then((value) {
      examen = value;
      if (examen != null) {
        examenMomentService.getExamenMomentsByExamId(examen!.id!).then((value) {
          momenten = value;
          for (var moment in momenten) {
            studentService.getById(moment.studentId).then((value) {
              setState(() {
                moment.student = value;
                _isLoading = false;
              });
            });
          }
        });
      } else {
        log("Geen examen");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultaten"),
        centerTitle: true,
      ),
      body: _isLoading
          ? LoadingScreen.showLoading()
          : Column(
              children: [
                Expanded(
                  child: momenten.isEmpty
                      ? const Center(child: Text("Hier komen resultaten"))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: momenten.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                  onTap: () {
                                    appData.currentExam = examen;
                                    appData.currentMoment = momenten[index];
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ResultPageDetail()));
                                  },
                                  title: Text(
                                      "${(momenten[index].student!.name)} (${examen!.naam})")),
                            );
                          }),
                ),
              ],
            ),
    );
  }
}
