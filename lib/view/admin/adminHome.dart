import 'package:examaker/view/admin/admin_studentOverview.dart';
import 'package:examaker/view/admin/change_password.dart';
import 'package:examaker/services/auth_service.dart';
import 'package:examaker/view/exam/createExam.dart';
import 'package:examaker/view/result/result.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminHomeState();
}

int _totaal = 0;
int _juistA = 0;
int _foutA = 0;

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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Results(
                            juistA: _juistA,
                            foutA: _foutA,
                            totaal: _totaal,
                          )));
                },
                child: const Text("Resultaten"),
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
