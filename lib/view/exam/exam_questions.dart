import 'package:examaker/model/examen.dart';
import 'package:examaker/model/vraag.dart';
import 'package:examaker/services/exam_service.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:examaker/view/admin/adminHome.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ExamQuestions extends StatefulWidget {
  const ExamQuestions({Key? key}) : super(key: key);

  @override
  State<ExamQuestions> createState() => _ExamQuestionsState();
}

class _ExamQuestionsState extends State<ExamQuestions> {
  Examen examen = appData.currentExam!;
  ExamService examService = ExamService();
  Uuid uuid = const Uuid();
  List<vraagWidget> vraagWidgets = [];
  final _formKey = GlobalKey<FormState>();
  late String vraagtekst, antwoord, keuzes;
  late int punten;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vraagWidgets = examen.vragen.map((vraag) {
      return vraagWidget(
        vraag: vraag,
      );
    }).toList();
  }

  void addOpenQuestion() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Voer een vraag in" : null,
                      decoration: const InputDecoration(hintText: "Vraag"),
                      onChanged: (val) {
                        vraagtekst = val;
                      },
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Geef een antwoord" : null,
                      decoration: const InputDecoration(hintText: "Antwoord"),
                      onChanged: (val) {
                        antwoord = val;
                      },
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Geef het aantal punten" : null,
                      decoration: const InputDecoration(hintText: "Punten"),
                      onChanged: (val) {
                        punten = int.parse(val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Vraag vraag =
                            Vraag.open(uuid.v4(), vraagtekst, antwoord, punten);
                        setState(() {
                          vraagWidgets.add(vraagWidget(vraag: vraag));
                          examen.vragen.add(vraag);
                        });
                      }
                    },
                    child: const Text("Toevoegen")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop("dialog");
                    },
                    child: const Text("Annuleer"))
              ],
            ));
  }

  void addCodeQuestion() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Voer een vraag in" : null,
                      decoration: const InputDecoration(hintText: "Vraag"),
                      onChanged: (val) {
                        vraagtekst = val;
                      },
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Geef het aantal punten" : null,
                      decoration: const InputDecoration(hintText: "Punten"),
                      onChanged: (val) {
                        punten = int.parse(val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Vraag vraag = Vraag.code(uuid.v4(), vraagtekst, punten);
                        setState(() {
                          vraagWidgets.add(vraagWidget(vraag: vraag));
                          examen.vragen.add(vraag);
                        });
                      }
                    },
                    child: const Text("Toevoegen")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop("dialog");
                    },
                    child: const Text("Annuleer"))
              ],
            ));
  }

  void addMcQuestion() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Voer een vraag in" : null,
                      decoration: const InputDecoration(hintText: "Vraag"),
                      onChanged: (val) {
                        vraagtekst = val;
                      },
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty
                          ? "Voer de opties in gescheiden met ';'"
                          : null,
                      decoration: const InputDecoration(
                          hintText: "Voer de opties in gescheiden met ';'"),
                      onChanged: (val) {
                        keuzes = val;
                      },
                    ),
                    TextFormField(
                      validator: (val) => !keuzes.contains(val!)
                          ? "Geef een antwoord uit de lijst"
                          : null,
                      decoration: const InputDecoration(hintText: "Antwoord"),
                      onChanged: (val) {
                        antwoord = val;
                      },
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Geef het aantal punten" : null,
                      decoration: const InputDecoration(hintText: "Punten"),
                      onChanged: (val) {
                        punten = int.parse(val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        List<Map<String, dynamic>> keuzesList = [];
                        for (var keuze in keuzes.split(";")) {
                          keuzesList.add({"keuze": keuze});
                        }
                        Vraag vraag = Vraag.multipleChoice(uuid.v4(),
                            vraagtekst, keuzesList, antwoord, punten);
                        setState(() {
                          vraagWidgets.add(vraagWidget(vraag: vraag));
                          examen.vragen.add(vraag);
                        });
                      }
                    },
                    child: const Text("Toevoegen")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop("dialog");
                    },
                    child: const Text("Annuleer"))
              ],
            ));
  }

  void save() async {
    examService.deleteExams().then((value) {
      examService.addExam(examen);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AdminHome()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(examen.naam),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: addOpenQuestion,
                    child: const Text("Open vraag")),
                ElevatedButton(
                    onPressed: addMcQuestion,
                    child: const Text("Multiple choice vraag")),
                ElevatedButton(
                    onPressed: addCodeQuestion,
                    child: const Text("Code vraag")),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: vraagWidgets,
                  ),
                ),
              ],
            )
          ]),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save),
            hoverElevation: 50,
            foregroundColor: Colors.white,
            onPressed: () => save()));
  }
}
