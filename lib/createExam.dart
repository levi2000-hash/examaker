import 'package:flutter/material.dart';

class createExam extends StatefulWidget {
  const createExam({ Key? key }) : super(key: key);

  @override
  State<createExam> createState() => _createExamState();
}

class _createExamState extends State<createExam> {
final _formKey = GlobalKey<FormState>();
late String examTitel, examBeschrijving;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            TextFormField(
              validator: (val) => val!.isEmpty ? "Geef examen titel " : null,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                hintText: "Examen titel"
              ),
              onChanged: (val){
                examTitel = val;
              },
            ),
            SizedBox(height: 5,),
          TextFormField(
              validator: (val) => val!.isEmpty ? "Geef examen beschrijving " : null,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                hintText: "Examen beschrijving"
              ),
              onChanged: (val){
                examBeschrijving = val;
              },
            ),
            Spacer(),
            Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Creër Examen",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
            SizedBox(height: 60,),
          ],),),)
    );
  }
}