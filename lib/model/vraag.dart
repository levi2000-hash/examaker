import 'package:flutter/cupertino.dart';

class Vraag {
  String vraag;
  VraagSoort vraagSoort;
  List<String> keuzes;
  String antwoord;
  int punten;

  Vraag(this.vraag, this.vraagSoort, this.keuzes, this.antwoord, this.punten);

  Widget build(BuildContext context) {
    if (vraagSoort == VraagSoort.open) {
      return Column(
        children: [
          Text(vraag),
        ],
      );
    }
  }
}

enum VraagSoort { code, multipleChoice, open }
