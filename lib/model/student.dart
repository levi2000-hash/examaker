import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String studentNumber;
  String name;

  Student(this.studentNumber, this.name);

  String studentNumberToId() {
    return "$studentNumber@ap.be";
  }

  String idToStudentNumber(String id) {
    return id.split("@ap.be")[0];
  }

  Student.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : name = snapshot.data()?["name"],
        studentNumber = snapshot.data()?["studentNumber"];

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "studentNumber": studentNumber,
    };
  }
}
