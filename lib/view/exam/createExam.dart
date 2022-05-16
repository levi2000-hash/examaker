import 'dart:developer';

import 'package:examaker/model/examen.dart';
import 'package:examaker/model/vraag.dart';
import 'package:examaker/services/exam_service.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:examaker/view/exam/exam_questions.dart';
import 'package:examaker/view/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateExam extends StatefulWidget {
  const CreateExam({Key? key}) : super(key: key);

  @override
  State<CreateExam> createState() => _CreateExamState();
}

class _CreateExamState extends State<CreateExam> {
  final _formKey = GlobalKey<FormState>();
  late String examTitel, examVak;
  late int examDuur;
  ExamService examService = ExamService();

  bool _isLoading = false;

  createExam() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Uuid uuid = const Uuid();
      Examen examen = Examen(uuid.v4(), [], examTitel, examVak, examDuur);

      await examService.addExam(examen).then((value) {
        setState(() {
          _isLoading = false;
          appData.currentExam = examen;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ExamQuestions()));
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

    Examen examen =
        Examen("testExamen2", vragen, "TestExamen2", "Flutter", 120);

    await examService.addExam(examen);
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
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "Geef duur " : null,
                        // ignore: prefer_const_constructors
                        decoration:
                            const InputDecoration(hintText: "Duur in minuten"),
                        onChanged: (val) {
                          examDuur = int.parse(val);
                        },
                      ),
                      ElevatedButton(
                          onPressed: createExam,
                          child: const Text("Creër Examen")),
                      ElevatedButton(
                          onPressed: testExamen,
                          child: const Text("Test Examen"))
                    ],
                  ),
                ),
              ));
  }
}
