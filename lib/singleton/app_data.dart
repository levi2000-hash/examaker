import 'package:examaker/model/Student.dart';

class AppData {
  static final AppData _appData = AppData._internal();

  Student? loggedInStudent;

  factory AppData() {
    return _appData;
  }

  AppData._internal();
}

final appData = AppData();
