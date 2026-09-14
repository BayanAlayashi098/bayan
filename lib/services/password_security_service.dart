class PasswordSecurityService {
  static double evaluatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    var score = 0.0;
    if (password.length >= 8) score += .2;
    if (password.length >= 12) score += .2;
    if (RegExp(r'[a-z]').hasMatch(password)) score += .15;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += .15;
    if (RegExp(r'[0-9]').hasMatch(password)) score += .15;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score += .15;

    return score.clamp(0.0, 1.0);
  }

  static String getStrengthLabel(double strength) {
    if (strength < .25) return 'Weak';
    if (strength < .5) return 'Medium';
    if (strength < .75) return 'Strong';
    return 'Very Strong';
  }

  static List<String> getTips(String password) {
    final tips = <String>[];
    if (password.length < 12) tips.add('Use at least 12 characters.');
    if (!RegExp(r'[A-Z]').hasMatch(password)) tips.add('Add uppercase letters.');
    if (!RegExp(r'[a-z]').hasMatch(password)) tips.add('Add lowercase letters.');
    if (!RegExp(r'[0-9]').hasMatch(password)) tips.add('Add numbers.');
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
      tips.add('Add special characters.');
    }
    return tips;
  }
}
