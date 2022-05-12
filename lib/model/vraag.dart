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
}

enum VraagSoort { code, multipleChoice, open }
