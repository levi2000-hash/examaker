import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  Future<void> addExamData(Map<String, dynamic> examData, String examId) async {
    await FirebaseFirestore.instance
        .collection("Exam")
        .doc(examId)
        .set(examData)
        .catchError((e) {
      log(e.toString());
    });
  }

  Future<List<Student>> getAllStudents() async {
    List<Student> students = [];
    final docRef = FirebaseFirestore.instance
        .collection("students")
        .withConverter(
            fromFirestore: Student.fromFirestore,
            toFirestore: (Student student, _) => student.toFirestore());
    return docRef.get().then((res) {
      for (var doc in res.docs) {
        students.add(doc.data());
      }
      return students;
    });
  }

  void saveStudents(List<Student> students) {
    for (var student in students) {
      FirebaseFirestore.instance
          .collection("students")
          .withConverter(
              fromFirestore: Student.fromFirestore,
              toFirestore: (Student student, _) => student.toFirestore())
          .doc(generateStudentDoc(student))
          .set(student, SetOptions(merge: true));
    }
  }

  void clearStudents() async {
    var students = await getAllStudents();

    for (var student in students) {
      FirebaseFirestore.instance
          .collection("students")
          .withConverter(
              fromFirestore: Student.fromFirestore,
              toFirestore: (Student student, _) => student.toFirestore())
          .doc(generateStudentDoc(student))
          .delete();
    }
  }

  String generateStudentDoc(Student student) {
    return student.studentNumber + "@ap.be";
  }
}

class Student {
  String studentNumber;
  String name;

  Student(this.studentNumber, this.name);

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
