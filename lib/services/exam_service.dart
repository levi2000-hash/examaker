import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/model/examen.dart';
import 'package:examaker/model/vraag.dart';

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
    Examen examen = examenDocs.docs[0].data();
    examen.id = examenDocs.docs[0].id;

    log(examen.id.toString());

    QuerySnapshot<Vraag> vraagDocs = await FirebaseFirestore.instance
        .collection("exam/${examen.id}/vragen")
        .withConverter(
            fromFirestore: Vraag.fromFirestore,
            toFirestore: (Vraag vraag, _) => vraag.toFirestore())
        .get();

    List<Vraag> vragen = [];

    for (var vraagdoc in vraagDocs.docs) {
      Vraag vraag = vraagdoc.data();
      vraag.id = vraagdoc.id;

      if (vraag.vraagSoort == VraagSoort.multipleChoice) {
        QuerySnapshot<
            Map<String,
                dynamic>> antwoordenDocs = await FirebaseFirestore.instance
            .collection(
                "exam/${examen.id}/vragen/${vraag.id}/MultipleChoiceAntwoorden")
            .get();
        vraag.keuzes = [];
        for (var antwoordDoc in antwoordenDocs.docs) {
          vraag.keuzes.add(antwoordDoc.data()["keuze"]);
        }
      }

      vragen.add(vraag);
    }

    examen.vragen = vragen;

    return examen;
  }
}
