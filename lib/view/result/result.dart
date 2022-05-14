import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  final int juistA, foutA, totaal;
  Results({required this.juistA,required this.foutA,required this.totaal});

  @override
  State createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("${widget.juistA}/${widget.totaal}"),
            SizedBox(height: 8,),
            Text("U hebt ${widget.juistA} juiste "
            "en ${widget.foutA} antwoorden beantwoord")

          ],),
          )
      ),
    );
  }
}