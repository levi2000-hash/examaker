import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/model/student.dart';
import 'package:examaker/services/student_service.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:examaker/view/student/studentHome.dart';
import 'package:flutter/material.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({Key? key}) : super(key: key);
  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  List<Student> students = [];
  StudentService studentService = StudentService();

  @override
  void initState() {
    super.initState();
    studentService.getAll().then((value) {
      setState(() {
        students = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Examator - AP Hogeschool"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text("Selecteer uw account"),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                        onTap: () => {
                              FirebaseFirestore.instance
                                  .collection("students")
                                  .doc("${students[index].studentNumber}@ap.be")
                                  .get()
                                  .then((value) => {
                                        if (value.exists)
                                          {
                                            appData.loggedInStudent =
                                                Student.fromFirestore(
                                                    value, null),
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            StudentHome()))
                                          }
                                      })
                            },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(students[index].name),
                            Text(students[index].studentNumber),
                          ],
                        )),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
