import 'package:examaker/services/auth.dart';
import 'package:examaker/services/validator.dart';
import 'package:examaker/view/admin/adminHome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
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

  void resetPassword() {
    final emailController = TextEditingController();
    final forgotPwKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Wachtwoord reset"),
        content: Form(
          key: forgotPwKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("email"),
              TextFormField(
                controller: emailController,
                validator: (value) => Validator.validateEmail(email: value),
              )
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                //Exit dialog
                if (forgotPwKey.currentState!.validate()) {
                  final _auth = FirebaseAuth.instance;
                  _auth.sendPasswordResetEmail(email: emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Email verzonden naar ${emailController.text}")));
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }
              },
              child: const Text("Reset")),
          ElevatedButton(
              onPressed: () {
                //Exit dialog
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: const Text("Annuleer"))
        ],
      ),
    );
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
            const SizedBox(height: 8.0),
            const Text("Password"),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (value) => Validator.validatePassword(password: value),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          User? user = await FireAuth.signInUsingEmailPassword(
                              email: usernameController.text,
                              password: passwordController.text);
                          if (user != null) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => AdminHome()));
                          }
                        }
                      },
                      child: const Text('Log in')),
                ),
                TextButton(
                    onPressed: resetPassword,
                    child: const Text("Wachtwoord vergeten?"))
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  User? user = await FireAuth.signInUsingEmailPassword(
                      email: "robbe.bevers@student.ap.be", password: "123456");
                  if (user != null) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AdminHome()));
                  }
                },
                child: const Text('bypass login'))
          ]),
        ));
  }
}
