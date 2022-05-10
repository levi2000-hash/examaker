import 'dart:developer';

import 'package:examaker/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> ChangePassword(String password) {
    final user = FirebaseAuth.instance.currentUser;
    log(user!.toString());

    return user.updatePassword(password);
  }
}
