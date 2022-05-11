import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/model/examen.dart';

class ExamService {
  Future<Map<String, dynamic>?> getById(String id) async {
    Map<String, dynamic>? examToGet;
    await FirebaseFirestore.instance
        .collection("Exam")
        .doc(id)
        .get()
        .then((exam) => {examToGet = exam.data()});
    return examToGet;
  }

  Future<void> addExamData(Map<String, dynamic> examData, String examId) async {
    await FirebaseFirestore.instance
        .collection("Exam")
        .doc(examId)
        .set(examData)
        .catchError((e) {
      log(e.toString());
    });
  }

  void save(Examen exam) {
    FirebaseFirestore.instance
        .collection("Exam")
        .withConverter(
            fromFirestore: Examen.fromFirestore,
            toFirestore: (Examen exam, _) => exam.toFirestore())
        .doc(exam.id)
        .set(exam, SetOptions(merge: true));
  }
}
