import 'package:examaker/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Check if app needs to be initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Examaker',
      theme: ThemeData(
        //Set main color theme
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class OpenExamenVraag extends StatelessWidget {
  const OpenExamenVraag(this.vraag);

  final String vraag;

  @override
  Widget build(BuildContext context) {
    const double width = 60;
    const double height = 40;
    return Container(
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            child: Text("$vraag"),
          ),
          const TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter answer"))
        ],
      ),
    );
  }
}
