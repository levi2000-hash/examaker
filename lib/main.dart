import 'package:examaker/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      title: 'Flutter Demo',
      theme: ThemeData(
        //Set main color theme
        primarySwatch: Colors.amber,
      ),
      home: const LoginPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final bool _completed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Examen Java"),
      ),
      body: Column(children: [
        //Vraag 1
        OpenExamenVraag("vraag 1"),
        OpenExamenVraag("Vraag 2")
      ]),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.check),
      ),
    );
  }
}

class OpenExamenVraag extends StatelessWidget {
  OpenExamenVraag(this.vraag);

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
