import 'package:examaker/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../services/validator.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AuthService auth = AuthService();

  void updatePassword(String password) {
    auth.ChangePassword(password).then((value) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Succes!"),
                content: const Text("Wachtwoord is gewijzigd"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        //Exit dialog
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        //Go back to admin home
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ],
              ));
    }).catchError((error) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Error"),
                content: const Text(
                    "Er ging iets fout bij het wijzigen van het wachtwoord"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                      child: const Text("OK"))
                ],
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wijzig wachtwoord"),
        centerTitle: true,
      ),
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(children: [
          Column(
            children: [
              const Text("Nieuw wachtwoord"),
              TextFormField(
                controller: passwordController,
                validator: (value) =>
                    Validator.validateNewPassword(password: value),
              )
            ],
          ),
          Column(
            children: [
              const Text("Herhaal wachtwoord"),
              TextFormField(
                controller: repeatPasswordController,
                validator: (value) => Validator.validateRepeatPassword(
                    password: passwordController.text, repeat: value),
              )
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  updatePassword(passwordController.text);
                }
              },
              child: const Text('Wijzig wachtwoord')),
        ]),
      )),
    );
  }
}
