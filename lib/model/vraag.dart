import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Vraag {
  String? id;
  String vraag;
  String vraagSoort;
  List<String> keuzes;
  String antwoord;
  int punten;

  Vraag(this.vraag, this.vraagSoort, this.keuzes, this.antwoord, this.punten)
      : id = null;

  Vraag.multipleChoice(
      this.id, this.vraag, this.keuzes, this.antwoord, this.punten)
      : vraagSoort = "MC";

  Vraag.open(this.id, this.vraag, this.antwoord, this.punten)
      : keuzes = [],
        vraagSoort = "OPEN";

  Vraag.code(this.id, this.vraag, this.punten)
      : keuzes = [],
        antwoord = "",
        vraagSoort = "CODE";

  Vraag.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : vraag = snapshot.data()?["vraag"],
        vraagSoort = snapshot.data()?["vraagSoort"],
        keuzes = [],
        antwoord = snapshot.data()?["antwoord"],
        punten = 0;

  Map<String, dynamic> toFirestore() {
    return {
      "vraag": vraag,
      "vraagSoort": vraagSoort,
      "antwoord": antwoord,
      "punten": punten
    };
  }

  Widget build(BuildContext context) {
    switch (vraagSoort) {
      case VraagSoort.multipleChoice:
        return (Column(
          children: [
            Text(vraag),
            Column(
              children: keuzes.map((keuze) {
                return Text(keuze);
              }).toList(),
            )
          ],
        ));
      default:
        return (Column(
          children: [Text(vraag), TextField()],
        ));
    }
  }
}

class VraagSoort {
  static const String code = "CODE";
  static const String multipleChoice = "MC";
  static const String open = "OPEN";
}
