import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class addQuestion extends StatefulWidget {
  @override
  State<addQuestion> createState() => _addQuestionState();
}

class _addQuestionState extends State<addQuestion> {
  final _formKey = GlobalKey<FormState>();
  late String vraag, optie1, optie2, optie3, optie4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            child: Column(children: [
              TextFormField(
                validator: (val) => val!.isEmpty ? "Geef de vraag in " : null,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(hintText: "Vraag"),
                onChanged: (val) {
                  vraag = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Geef optie1" : null,
                // ignore: prefer_const_constructors
                decoration:
                    InputDecoration(hintText: "Optie1 (Juiste Antwoord)"),
                onChanged: (val) {
                  optie1 = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Geef Optie2" : null,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(hintText: "Optie1"),
                onChanged: (val) {
                  optie2 = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Geef Optie3" : null,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(hintText: "Optie3"),
                onChanged: (val) {
                  optie3 = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Geef Optie4" : null,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(hintText: "Optie4"),
                onChanged: (val) {
                  optie4 = val;
                },
              ),
              Spacer(),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 2 - 36,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Indienen",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      //TODO
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2 - 36,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "vraag toevoegen",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 60,
              ),
            ])));
  }
}
