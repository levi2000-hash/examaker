import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges();
    User? student;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      student = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        print("Wrong password!");
      } else if (e.code == "user-not-found") {
        print("No use found for that email");
      }
    }
    return student;
  }
}
