import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examaker/services/validator.dart';
import 'package:flutter/material.dart';

class Vraag {
  String? id;
  String vraag;
  String vraagSoort;
  List<Map<String, dynamic>> keuzes;
  String antwoord;
  int punten;

  Vraag(this.vraag, this.vraagSoort, this.keuzes, this.antwoord, this.punten)
      : id = null;

  Vraag.multipleChoice(
      this.id, this.vraag, this.keuzes, this.antwoord, this.punten)
      : vraagSoort = "MC";

  Vraag.open(this.id, this.vraag, this.antwoord, this.punten)
      : keuzes = [],
        vraagSoort = "OPEN";

  Vraag.code(this.id, this.vraag, this.punten)
      : keuzes = [],
        antwoord = "",
        vraagSoort = "CODE";

  Vraag.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : vraag = snapshot.data()?["vraag"],
        vraagSoort = snapshot.data()?["vraagSoort"],
        keuzes = [],
        antwoord = snapshot.data()?["antwoord"],
        punten = 0;

  Map<String, dynamic> toFirestore() {
    return {
      "vraag": vraag,
      "vraagSoort": vraagSoort,
      "antwoord": antwoord,
      "punten": punten
    };
  }
}

class vraagWidget extends StatefulWidget {
  vraagWidget({Key? key, required this.vraag}) : super(key: key);

  final Vraag vraag;
  final TextEditingController answerController = TextEditingController();
  String? keuze = "";

  @override
  State<vraagWidget> createState() => _vraagWidgetState();
}

class _vraagWidgetState extends State<vraagWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.vraag.vraagSoort) {
      case VraagSoort.multipleChoice:
        return Card(
          borderOnForeground: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (Column(
              children: [
                Text(
                  widget.vraag.vraag,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Column(
                  children: widget.vraag.keuzes.map((keuze) {
                    return ListTile(
                      title: Text(keuze["keuze"]),
                      leading: Radio<String>(
                        value: keuze["keuze"],
                        groupValue: widget.keuze,
                        onChanged: (String? value) {
                          setState(() {
                            widget.keuze = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            )),
          ),
        );
      default:
        return Card(
          borderOnForeground: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      widget.vraag.vraag,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextFormField(
                      maxLines: 5,
                      controller: widget.answerController,
                      validator: (value) =>
                          Validator.validateAnswer(answer: value),
                    )
                  ],
                ))),
          ),
        );
    }
  }
}

class VraagSoort {
  static const String code = "CODE";
  static const String multipleChoice = "MC";
  static const String open = "OPEN";
}
