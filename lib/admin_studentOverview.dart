import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:examaker/services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentOverview extends StatefulWidget {
  const StudentOverview({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _StudentOverviewState();
}

class _StudentOverviewState extends State<StudentOverview> {
  List<Student> students = [];
  DatabaseService db = DatabaseService();

  void _openFileExplorer() async {
    List<PlatformFile> _paths = [];
    try {
      FilePicker.platform.clearTemporaryFiles();
      _paths = (await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowMultiple: false,
              allowedExtensions: (["csv"])))!
          .files;
    } on PlatformException catch (e) {
      log("Unsupported operation " + e.toString());
    } catch (ex) {
      log(ex.toString());
    }

    if (!mounted) return;
    setState(() {
      _loadCSV(_paths.single);
    });
  }

  void _loadCSV(PlatformFile path) async {
    File f = File(path.path!);
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter(fieldDelimiter: ";"))
        .toList();

    setState(() {
      fields.removeAt(0); //Remove heading of csv file
      addToStudents(fields);
    });
  }

  void addToStudents(fields) {
    for (var csvStudent in fields) {
      if (students
          .where((element) => element.studentNumber == csvStudent[0])
          .isEmpty) {
        students.add(Student(csvStudent[0], csvStudent[1]));
      }
    }
  }

  void saveToFirebase() {
    db.saveStudents(students);
  }

  void deleteStudents() {
    db.clearStudents();
    setState(() {
      students = [];
    });
  }

  @override
  void initState() {
    super.initState();
    db.getAllStudents().then((value) {
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
      //LoginForm
      body: Column(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.green,
                height: 30,
                child: TextButton(
                  child: const Text(
                    "Import students",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: kIsWeb ? null : _openFileExplorer,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.green,
                height: 30,
                child: TextButton(
                  child: const Text(
                    "Save to db",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: saveToFirebase,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.green,
                height: 30,
                child: TextButton(
                  child: const Text(
                    "Delete all students",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: deleteStudents,
                ),
              ),
            ),
          ]),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(students[index].name),
                          Text(students[index].studentNumber),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
