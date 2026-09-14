import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ScanButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;

  const ScanButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGreen,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
