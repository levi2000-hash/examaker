import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/model/vraag.dart';

class Examen {
  String? id;
  List<Vraag> vragen;
  String naam;
  String vak;
  int punten;

  Examen(this.id, this.vragen, this.naam, this.vak, this.punten);

  Examen.withoutId(this.vragen, this.naam, this.vak, this.punten) : id = null;

  Examen.withoutVragen(this.id, this.naam, this.vak)
      : vragen = [],
        punten = 0;

  Examen.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : naam = snapshot.data()?["naam"],
        vragen = snapshot.data()?["vragen"],
        vak = snapshot.data()?["vak"],
        punten = snapshot.data()?["punten"];

  Map<String, dynamic> toFirestore() {
    return {"naam": naam, "vragen": vragen, "vak": vak, "punten": punten};
  }
}
