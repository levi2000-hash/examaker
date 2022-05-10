class Validator {
  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }
    if (email.isEmpty) {
      return 'Email kan niet leeg zijn';
    }
    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Wachtwoord kan niet leeg zijn';
    }
    return null;
  }

  static String? validateNewPassword({required String? password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty || password.length < 6) {
      return "Wachtwoord moet minstens 6 karakters lang zijn.";
    }
    return null;
  }

  static String? validateRepeatPassword(
      {required String? password, required String? repeat}) {
    if (password == null || repeat == null) {
      return null;
    }
    if (password != repeat) {
      return "Wachtwoorden komen niet overeen";
    }
    return null;
  }
}
