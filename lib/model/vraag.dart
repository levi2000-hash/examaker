class Vraag {
  String vraag;
  VraagSoort vraagSoort;
  List<String> keuzes;
  String antwoord;
  int punten;

  Vraag(this.vraag, this.vraagSoort, this.keuzes, this.antwoord, this.punten);
}

enum VraagSoort { code, multipleChoice, open }
