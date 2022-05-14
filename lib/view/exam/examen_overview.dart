import 'package:examaker/model/examen.dart';
import 'package:examaker/services/exam_service.dart';
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
                  child: Center(
                      child: Row(
                    children: [Text(examen!.naam)],
                  )),
                ),
              ))),
    );
  }
}
