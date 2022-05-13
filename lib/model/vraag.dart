import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Vraag {
  String vraag;
  VraagSoort vraagSoort;
  List<String> keuzes;
  String antwoord;
  int punten;

  Vraag(this.vraag, this.vraagSoort, this.keuzes, this.antwoord, this.punten);

  Vraag.multipleChoice(this.vraag, this.keuzes, this.antwoord, this.punten)
      : vraagSoort = VraagSoort.multipleChoice;

  Vraag.open(this.vraag, this.antwoord, this.punten)
      : keuzes = [],
        vraagSoort = VraagSoort.open;

  Vraag.code(this.vraag, this.punten)
      : keuzes = [],
        antwoord = "",
        vraagSoort = VraagSoort.code;

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
        break;
      default:
        return (Column(
          children: [Text(vraag), TextField()],
        ));
    }
  }
}

enum VraagSoort { code, multipleChoice, open }
