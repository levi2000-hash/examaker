import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/model/student.dart';

class StudentService {
  Future<void> addExamData(Map<String, dynamic> examData, String examId) async {
    await FirebaseFirestore.instance
        .collection("Exam")
        .doc(examId)
        .set(examData)
        .catchError((e) {
      log(e.toString());
    });
  }

  Future<List<Student>> getAll() async {
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

  Future<Student> getById(String studentId) async {
    final docRef = FirebaseFirestore.instance
        .collection("students")
        .withConverter(
            fromFirestore: Student.fromFirestore,
            toFirestore: (Student student, _) => student.toFirestore())
        .doc(studentId);

    return docRef.get().then((value) {
      return value.data()!;
    });
  }

  void save(List<Student> students) {
    for (var student in students) {
      FirebaseFirestore.instance
          .collection("students")
          .withConverter(
              fromFirestore: Student.fromFirestore,
              toFirestore: (Student student, _) => student.toFirestore())
          .doc(student.studentNumberToId())
          .set(student, SetOptions(merge: true));
    }
  }

  void deleteAll() async {
    var students = await getAll();

    for (var student in students) {
      FirebaseFirestore.instance
          .collection("students")
          .withConverter(
              fromFirestore: Student.fromFirestore,
              toFirestore: (Student student, _) => student.toFirestore())
          .doc(student.studentNumberToId())
          .delete();
    }
  }
}
