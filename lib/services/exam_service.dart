import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/model/examen.dart';
import 'package:examaker/model/vraag.dart';
import 'package:uuid/uuid.dart';

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
      log("Exam: " + e.toString());
    });

    for (var vraag in examen.vragen) {
      await FirebaseFirestore.instance
          .collection("exam/${examen.id}/vragen")
          .withConverter(
              fromFirestore: Vraag.fromFirestore,
              toFirestore: (Vraag vraag, _) => vraag.toFirestore())
          .doc(vraag.id)
          .set(vraag, SetOptions(merge: true))
          .catchError((e) {
        log("Vraag: " + e.toString());
      });

      if (vraag.vraagSoort == VraagSoort.multipleChoice) {
        Uuid uuid = const Uuid();
        for (var keuze in vraag.keuzes) {
          await FirebaseFirestore.instance
              .collection("exam/${examen.id}/vragen/${vraag.id}/keuzes")
              .doc(uuid.v4())
              .set(keuze);
        }
      }
    }
  }

  Future<void> deleteExams() async {
    QuerySnapshot<Map<String, dynamic>> examenDocs =
        await FirebaseFirestore.instance.collection("exam").get();

    for (var docs in examenDocs.docs) {
      docs.reference.delete();

      QuerySnapshot<Map<String, dynamic>> vraagDocs = await FirebaseFirestore
          .instance
          .collection("exam/${docs.id}/vragen")
          .get();

      for (var vraagdoc in vraagDocs.docs) {
        vraagdoc.reference.delete();
        if (vraagdoc.data()["vraagSoort"] == VraagSoort.multipleChoice) {
          QuerySnapshot<Map<String, dynamic>> antwoordenDocs =
              await FirebaseFirestore.instance
                  .collection("exam/${docs.id}/vragen/${vraagdoc.id}/keuzes")
                  .get();

          for (var antwoordDoc in antwoordenDocs.docs) {
            antwoordDoc.reference.delete();
          }
        }
      }
    }
  }

  Future<Examen?> getExamen() async {
    QuerySnapshot<Examen> examenDocs = await FirebaseFirestore.instance
        .collection("exam")
        .withConverter(
            fromFirestore: Examen.fromFirestore,
            toFirestore: (Examen examen, _) => examen.toFirestore())
        .where("naam", isEqualTo: "TestExamen") //TODO: Delete this line
        .get();

    //Get first Exam. There can only be one exam

    if (examenDocs.docs.isEmpty) {
      return null;
    }
    Examen examen = examenDocs.docs[0].data();
    examen.id = examenDocs.docs[0].id;

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
        QuerySnapshot<Map<String, dynamic>> antwoordenDocs =
            await FirebaseFirestore.instance
                .collection("exam/${examen.id}/vragen/${vraag.id}/keuzes")
                .get();
        vraag.keuzes = [];
        for (var antwoordDoc in antwoordenDocs.docs) {
          vraag.keuzes.add(
              {"keuze": antwoordDoc.data()["keuze"], "id": antwoordDoc.id});
        }
      }

      vragen.add(vraag);
    }

    examen.vragen = vragen;

    return examen;
  }
}
