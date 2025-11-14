class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is not secure';
    }
    return null;
  }
}
