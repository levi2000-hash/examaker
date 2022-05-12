import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/model/examen.dart';

class ExamService {
  Future<void> addExam(Examen examen) async {
    await FirebaseFirestore.instance
        .collection("exam")
        .withConverter(
            fromFirestore: Examen.fromFirestore,
            toFirestore: (Examen examen, _) => examen.toFirestore())
        .doc(examen.id)
        .set(examen, SetOptions(merge: true))
        .catchError((e) {
      log(e.toString());
    });
  }

  Future<Examen> getExamen() async {
    QuerySnapshot<Examen> examenDocs = await FirebaseFirestore.instance
        .collection("exam")
        .withConverter(
            fromFirestore: Examen.fromFirestore,
            toFirestore: (Examen examen, _) => examen.toFirestore())
        .get();

    //Get first Exam. There can only be one exam
    return examenDocs.docs[0].data();
  }
}
