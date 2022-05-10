import 'package:examaker/admin_studentOverview.dart';
import 'package:examaker/change_password.dart';
import 'package:examaker/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'createExam.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  AuthService auth = AuthService();

  void changePassword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Admin dashboard"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const StudentOverview()))
                },
                child: const Text("Studenten"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const createExam()));
                },
                child: const Text("Examen maken"),
              ),
              ElevatedButton(
                onPressed: null,
                child: Text("Resultaten"),
              ),
              ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangePassword()))
                },
                child: const Text("Wijzig wachtwoord"),
              ),
            ],
          ),
        ));
  }
}
