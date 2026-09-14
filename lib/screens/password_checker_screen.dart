import 'package:flutter/material.dart';
import '../services/password_security_service.dart';
import '../widgets/password_strength.dart';

class PasswordCheckerScreen extends StatefulWidget {
  const PasswordCheckerScreen({super.key});

  @override
  State<PasswordCheckerScreen> createState() => _PasswordCheckerScreenState();
}

class _PasswordCheckerScreenState extends State<PasswordCheckerScreen> {
  final controller = TextEditingController();
  double strength = 0;
  bool obscure = true;

  void evaluate(String value) {
    setState(() {
      strength = PasswordSecurityService.evaluatePasswordStrength(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final label = PasswordSecurityService.getStrengthLabel(strength);
    final tips = PasswordSecurityService.getTips(controller.text);

    return Scaffold(
      appBar: AppBar(title: const Text('Password Security Checker')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller,
            obscureText: obscure,
            onChanged: evaluate,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () => setState(() => obscure = !obscure),
                icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
          const SizedBox(height: 24),
          PasswordStrength(strength: strength, label: label),
          const SizedBox(height: 24),
          if (tips.isNotEmpty) ...[
            const Text('Improvement Tips',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(tip)),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
