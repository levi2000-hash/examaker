import 'package:examaker/model/examen.dart';
import 'package:examaker/services/exam_moment_service.dart';
import 'package:examaker/services/exam_service.dart';
import 'package:examaker/singleton/app_data.dart';
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
  ExamenMomentService examMomentService = ExamenMomentService();

  @override
  void initState() {
    super.initState();
    examService.getExamen().then((value) {
      setState(() {
        examen = value;
        appData.currentExam = value;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Examenbeheer"),
          centerTitle: true,
        ),
        body: _isLoading
            ? LoadingScreen.showLoading()
            : appData.currentExam != null
                ? Container(
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ElevatedButton(
                                        onPressed: null,
                                        child: Text("Bewerken")),
                                  ),
                                  ElevatedButton(
                                      onPressed: null,
                                      child: Text("Verwijderen"))
                                ],
                              ),
                            ],
                          )),
                        ),
                      ),
                    )))
                : const Center(
                    child: Text("Voeg een examen toe via de knop onderaan."),
                  ),
        floatingActionButton: FloatingActionButton(
            onPressed: toCreateExam, child: const Icon(Icons.add)));
  }

  toCreateExam() {
    if (appData.currentExam == null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const CreateExam()));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Nieuw examen maken?"),
                content: const Text(
                    "Huidig examen en resultaten worden verwijderd."),
                actions: [
                  ElevatedButton(
                      onPressed: (() {
                        examMomentService
                            .deleteMoments(appData.currentExam!.id!)
                            .then((value) {
                          examService.deleteExams().then((value) {
                            appData.currentExam = null;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CreateExam()));
                          });
                        });
                      }),
                      child: const Text("Ja")),
                  ElevatedButton(
                      onPressed: (() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      }),
                      child: const Text("Nee")),
                ],
              ));
    }
  }
}
