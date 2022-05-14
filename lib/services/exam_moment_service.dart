import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/model/examenMoment.dart';

class ExamenMomentService {
  Future<void> addExamenMoment(ExamenMoment examenMoment) async {
    await FirebaseFirestore.instance
        .collection("examMoment")
        .withConverter(
            fromFirestore: ExamenMoment.fromFirestore,
            toFirestore: (ExamenMoment examenMoment, _) =>
                examenMoment.toFirestore())
        .doc(examenMoment.id)
        .set(examenMoment, SetOptions(merge: true))
        .catchError((e) {
      log(e.toString());
    });

    for (var antwoord in examenMoment.antwoorden!) {
      await FirebaseFirestore.instance
          .collection("examMoment/${examenMoment.id}/antwoorden")
          .doc()
          .set(antwoord, SetOptions(merge: true))
          .catchError((e) {
        log(e.toString());
      });
    }
  }

  Future<ExamenMoment> getExamenMomentByStudentIdAndExamId(
      String studentId, String examId) async {
    QuerySnapshot<ExamenMoment> examenMomentDocs = await FirebaseFirestore
        .instance
        .collection("examMoment")
        .withConverter(
            fromFirestore: ExamenMoment.fromFirestore,
            toFirestore: (ExamenMoment examenMoment, _) =>
                examenMoment.toFirestore())
        .where("studentId", isEqualTo: studentId)
        .where("examenId", isEqualTo: examId)
        .get();

    ExamenMoment examenMoment = examenMomentDocs.docs[0].data();
    examenMoment.id = examenMomentDocs.docs[0].id;
    examenMoment.antwoorden = await getExamenAntwoorden(examenMoment.id!);

    return examenMoment;
  }

  Future<List<Map<String, dynamic>>> getExamenAntwoorden(
      String examenMomentId) async {
    QuerySnapshot<Map<String, dynamic>> antwoordenDocs = await FirebaseFirestore
        .instance
        .collection("examMoment/$examenMomentId/antwoorden")
        .get();
    List<Map<String, dynamic>> antwoorden = [];
    for (var antwoordDoc in antwoordenDocs.docs) {
      antwoorden.add(antwoordDoc.data());
    }

    return antwoorden;
  }

  Future<List<ExamenMoment>> getExamenMomentsByExamId(String examId) async {
    QuerySnapshot<ExamenMoment> examenMomentDocs = await FirebaseFirestore
        .instance
        .collection("examMoment")
        .withConverter(
            fromFirestore: ExamenMoment.fromFirestore,
            toFirestore: (ExamenMoment examenMoment, _) =>
                examenMoment.toFirestore())
        .where("examenId", isEqualTo: examId)
        .get();

    List<ExamenMoment> momenten = [];

    for (var momentDoc in examenMomentDocs.docs) {
      ExamenMoment moment = momentDoc.data();
      moment.id = momentDoc.id;
      moment.antwoorden = await getExamenAntwoorden(moment.id!);
      momenten.add(moment);
    }

    return momenten;
  }
}
