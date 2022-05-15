import 'dart:developer';

import 'package:examaker/model/examen.dart';
import 'package:examaker/model/vraag.dart';
import 'package:examaker/services/exam_service.dart';
import 'package:examaker/view/exam/addQuestion.dart';
import 'package:examaker/view/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:uuid/uuid.dart';

class CreateExam extends StatefulWidget {
  const CreateExam({Key? key}) : super(key: key);

  @override
  State<CreateExam> createState() => _CreateExamState();
}

class _CreateExamState extends State<CreateExam> {
  final _formKey = GlobalKey<FormState>();
  late String examTitel, examVak, examId;
  ExamService examService = ExamService();

  bool _isLoading = false;

  createExamOnline() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      examId = randomAlphaNumeric(16);

      Uuid uuid = const Uuid();
      Examen examen = Examen(uuid.v4(), [], examTitel, examVak, 0);

      await examService.addExam(examen).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => addQuestion()));
        });
      });
    }
  }

  void testExamen() async {
    Uuid uuid = const Uuid();
    List<Vraag> vragen = [];
    vragen.add(Vraag.code(uuid.v4(), "Schrijf een for loop", 10));
    List<Map<String, dynamic>> keuzes = [
      {"keuze": "a"},
      {"keuze": "b"},
      {"keuze": "c"},
    ];
    vragen.add(Vraag.multipleChoice(uuid.v4(), "A, B of C?", keuzes, "c", 5));
    vragen.add(Vraag.open(uuid.v4(), "Open vraag", "Ja", 1));

    Examen examen = Examen("testExamen", vragen, "TestExamen", "Flutter", 120);

    await examService.addExam(examen);
    log("Done");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Examen aanmaken"),
          centerTitle: true,
        ),
        body: _isLoading
            ? LoadingScreen.showLoading()
            : Form(
                key: _formKey,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Geef examen titel " : null,
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(hintText: "Examen titel"),
                        onChanged: (val) {
                          examTitel = val;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "Geef vak " : null,
                        // ignore: prefer_const_constructors
                        decoration: const InputDecoration(hintText: "Vak"),
                        onChanged: (val) {
                          examVak = val;
                        },
                      ),
                      ElevatedButton(
                          onPressed: testExamen,
                          child: const Text("Creër Examen"))
                    ],
                  ),
                ),
              ));
  }
}
