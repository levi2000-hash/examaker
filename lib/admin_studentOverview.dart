import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
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
  List<List<dynamic>> _data = [];

  void _openFileExplorer() async {
    List<PlatformFile> _paths = [];
    try {
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
      _data = fields;
      _data.removeAt(0); //Remove heading of csv file
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.green,
              height: 30,
              child: TextButton(
                child: const Text(
                  "CSV To List",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: kIsWeb ? null : _openFileExplorer,
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_data[index][0]),
                        Text(_data[index][1]),
                        Text(_data[index][2]),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
