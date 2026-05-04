class ValidationService {
  // Allowed email domains
  static const List<String> allowedDomains = [
    'gmail.com',
    'outlook.com',
    'yahoo.com',
    'atu.edu',
  ];

  // Email validation with domain whitelist
  static String? validateEmailDomain(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    if (!value.contains('@') || !value.contains('.')) {
      return "Enter a valid email format";
    }

    final domain = value.split('@').last.toLowerCase();

    if (!allowedDomains.contains(domain)) {
      return "Email must be from: ${allowedDomains.join(', ')}";
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    if (value.length > 64) {
      return "Password is too long";
    }

    final uppercase = RegExp(r'[A-Z]');
    final number = RegExp(r'\d');
    final special = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (!uppercase.hasMatch(value)) {
      return "Password must contain an uppercase letter";
    }
    if (!number.hasMatch(value)) {
      return "Password must contain a number";
    }
    if (!special.hasMatch(value)) {
      return "Password must contain a special character";
    }
    return null;
  }

  // Confirm password matches
  static String? validateConfirmPassword(
      String? value, String passwordValue) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != passwordValue) {
      return "Passwords do not match";
    }
    return null;
  }

  // Name validation (First/Last name)
  static String? validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }
    if (value.length < 2) {
      return "$fieldName must be at least 2 characters";
    }
    if (value.length > 20) {
      return "$fieldName must not exceed 20 characters";
    }
    // Only letters and spaces allowed
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return "$fieldName can only contain letters and spaces";
    }
    return null;
  }

  // Generic text field validation
  static String? validateTextField(String? value, String fieldName,
      {int minLength = 1, int maxLength = 100, bool allowNumbers = false}) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }
    if (value.length < minLength) {
      return "$fieldName must be at least $minLength characters";
    }
    if (value.length > maxLength) {
      return "$fieldName must not exceed $maxLength characters";
    }

    if (!allowNumbers) {
      final textRegex = RegExp(r'^[a-zA-Z\s]+$');
      if (!textRegex.hasMatch(value)) {
        return "$fieldName can only contain letters and spaces";
      }
    }
    return null;
  }
}
