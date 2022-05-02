import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/adminHome.dart';
import 'package:examaker/main.dart';
import 'package:examaker/studentHome.dart';
import 'package:examaker/validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({Key? key}) : super(key: key);
  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final usernameController = TextEditingController();
  Map<String, dynamic> data = Map<String, dynamic>();
  final _formKey = GlobalKey<FormState>();

  //Dispose of controller when widget dissapears
  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Examator - AP Hogeschool"),
          centerTitle: true,
        ),
        //LoginForm
        body: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            const Text("Username"),
            TextFormField(
              controller: usernameController,
              validator: (value) => Validator.validateEmail(email: value),
            ),
            ElevatedButton(
                onPressed: () async {
                  checkEmail();
                },
                child: const Text('Log in'))
          ]),
        ));
  }
  checkEmail(){
    FirebaseFirestore instance = FirebaseFirestore.instance;
    instance.collection('students')
      .doc(usernameController.text)
      .get()
      .then((DocumentSnapshot snapshot) => {
          data = snapshot.data() as Map<String, dynamic>,
          if(data['email'] == usernameController.text){
              Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => StudentHome()))
          }
        }
      );
  }
}