import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/model/vraag.dart';

class Examen {
  String? id;
  //Todo: Change back to Vraag and find out how subsets work
  List<Vraag> vragen;
  String naam;
  String vak;
  int punten;
  int duur;

  Examen(this.id, this.vragen, this.naam, this.vak, this.punten, this.duur);

  Examen.withoutId(this.vragen, this.naam, this.vak, this.punten, this.duur)
      : id = null;

  Examen.withoutVragen(this.id, this.naam, this.vak, this.duur)
      : vragen = [],
        punten = 0;

  Examen.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : naam = snapshot.data()?["naam"],
        vragen = [],
        vak = snapshot.data()?["vak"],
        punten = snapshot.data()?["punten"],
        duur = snapshot.data()?["duur"];

  Map<String, dynamic> toFirestore() {
    return {"naam": naam, "vak": vak, "punten": punten, "duur": duur};
  }
}
