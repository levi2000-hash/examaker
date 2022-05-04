import 'package:examaker/studentLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'admin_login.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () => {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => StudentLoginPage()))
                },
            child: const Text("Student")),
        ElevatedButton(
            onPressed: () => {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AdminLoginPage()))
                },
            child: const Text("Admin"))
      ],
    );
  }
}
