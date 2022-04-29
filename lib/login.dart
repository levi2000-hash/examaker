import 'package:examaker/main.dart';
import 'package:examaker/validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //Dispose of controller when widget dissapears
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
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
            TextFormField(
              controller: usernameController,
              validator: (value) => Validator.validateEmail(email: value),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (value) => Validator.validatePassword(password: value),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    User? user = await FireAuth.signInUsingEmailPassword(
                        email: usernameController.text,
                        password: passwordController.text);
                    if (user != null) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MainPage()));
                    }
                  }
                },
                child: const Text('Log in'))
          ]),
        ));
  }
}
