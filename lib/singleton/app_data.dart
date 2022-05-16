import 'package:examaker/model/examen.dart';
import 'package:examaker/model/student.dart';

class AppData {
  static final AppData _appData = AppData._internal();

  Student? loggedInStudent;

  Examen? currentExam;

  factory AppData() {
    return _appData;
  }

  AppData._internal();
}

final appData = AppData();
