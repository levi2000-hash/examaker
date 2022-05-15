import 'package:examaker/model/examen.dart';
import 'package:examaker/model/vraag.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ExamQuestions extends StatefulWidget {
  const ExamQuestions({Key? key}) : super(key: key);

  @override
  State<ExamQuestions> createState() => _ExamQuestionsState();
}

class _ExamQuestionsState extends State<ExamQuestions> {
  Examen examen = appData.currentExam!;
  Uuid uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    List<Vraag> vragen = [];
    vragen.add(Vraag.code(uuid.v4(), "Schrijf een for loop", 10));
    List<Map<String, dynamic>> keuzes = [
      {"keuze": "a"},
      {"keuze": "b"},
      {"keuze": "c"},
    ];
    vragen.add(Vraag.multipleChoice(uuid.v4(), "A, B of C?", keuzes, "c", 5));
    vragen.add(Vraag.open(uuid.v4(), "Open vraag", "Ja", 1));
    examen.vragen = vragen;

    return Scaffold(
      appBar: AppBar(
        title: Text(examen.naam),
        centerTitle: true,
      ),
      body: Center(
        child: Text(examen.vragen.length.toString()),
      ),
    );
  }
}
