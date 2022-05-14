import 'package:cloud_firestore/cloud_firestore.dart';

class ExamenMoment {
  String? id;
  String studentId;
  String examenId;
  int lon;
  int lat;
  String adres;
  int outOfFocusCount;
  bool finished;
  List<Map<String, dynamic>>? antwoorden;

  //TODO: Antwoorden bijhouden

  ExamenMoment(this.id, this.studentId, this.examenId, this.lon, this.lat,
      this.adres, this.outOfFocusCount)
      : finished = false,
        antwoorden = [];

  ExamenMoment.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : studentId = snapshot.data()?["studentId"],
        examenId = snapshot.data()?["examenId"],
        lon = snapshot.data()?["lon"],
        lat = snapshot.data()?["lat"],
        adres = snapshot.data()?["adres"],
        outOfFocusCount = snapshot.data()?["outOfFocusCount"],
        finished = snapshot.data()?["finished"];

  Map<String, dynamic> toFirestore() {
    return {
      "studentId": studentId,
      "examenId": examenId,
      "lon": lon,
      "lat": lat,
      "adres": adres,
      "outOfFocusCount": outOfFocusCount,
      "finished": finished
    };
  }
}
