import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PasswordStrength extends StatelessWidget {
  final double strength;
  final String label;

  const PasswordStrength({
    super.key,
    required this.strength,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: strength,
          minHeight: 9,
          borderRadius: BorderRadius.circular(20),
          backgroundColor: AppColors.card,
          color: AppColors.neonGreen,
        ),
        const SizedBox(height: 10),
        Text(label,
            style: const TextStyle(
                color: AppColors.neonGreen, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
