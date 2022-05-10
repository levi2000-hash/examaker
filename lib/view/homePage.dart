import 'package:examaker/view/student/studentLogin.dart';
import 'package:flutter/material.dart';

import '../admin/admin_login.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Examaker - AP Hogeschool"),
        centerTitle: true,
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  "Welkom",
                  style: TextStyle(fontSize: 32),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StudentLoginPage()))
                          },
                      child: const Text("Student")),
                  ElevatedButton(
                      onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AdminLoginPage()))
                          },
                      child: const Text("Admin"))
                ],
              )
            ],
          )),
    );
  }
}
