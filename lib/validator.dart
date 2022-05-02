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
  }
}
