import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/services/validator.dart';
import 'package:flutter/material.dart';

class Vraag {
  String? id;
  String vraag;
  String vraagSoort;
  List<String> keuzes;
  String antwoord;
  int punten;

  final answerController = TextEditingController();

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
        String? _keuze = "";
        return (Column(
          children: [
            Text(vraag),
            Column(
              children: keuzes.map((keuze) {
                return ListTile(
                  title: Text(keuze),
                  leading: Radio<String>(
                    value: keuze,
                    groupValue: _keuze,
                    onChanged: (String? value) {
                      _keuze = value;
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ));
      default:
        return (Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(vraag),
                TextFormField(
                  controller: answerController,
                  validator: (value) => Validator.validateAnswer(answer: value),
                )
              ],
            )));
    }
  }
}

class VraagSoort {
  static const String code = "CODE";
  static const String multipleChoice = "MC";
  static const String open = "OPEN";
}
