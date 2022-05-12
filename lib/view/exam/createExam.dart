import 'package:examaker/model/examen.dart';
import 'package:examaker/services/exam_service.dart';
import 'package:examaker/view/exam/addQuestion.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:uuid/uuid.dart';

class createExam extends StatefulWidget {
  const createExam({Key? key}) : super(key: key);

  @override
  State<createExam> createState() => _createExamState();
}

class _createExamState extends State<createExam> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
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
                        validator: (val) =>
                            val!.isEmpty ? "Geef examen beschrijving " : null,
                        // ignore: prefer_const_constructors
                        decoration: const InputDecoration(hintText: "Vak"),
                        onChanged: (val) {
                          examVak = val;
                        },
                      ),
                      ElevatedButton(
                          onPressed: createExamOnline,
                          child: const Text("Creër Examen"))
                    ],
                  ),
                ),
              ));
  }
}
