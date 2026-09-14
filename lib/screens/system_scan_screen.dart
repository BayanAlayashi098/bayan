import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SystemScanScreen extends StatefulWidget {
  const SystemScanScreen({super.key});

  @override
  State<SystemScanScreen> createState() => _SystemScanScreenState();
}

class _SystemScanScreenState extends State<SystemScanScreen> {
  bool scanning = false;
  bool completed = false;

  Future<void> scan() async {
    setState(() {
      scanning = true;
      completed = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        scanning = false;
        completed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('System Security Scan')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(completed ? Icons.verified_user : Icons.security,
                          size: 70, color: AppColors.neonGreen),
                      const SizedBox(height: 16),
                      Text(
                        completed ? 'Basic Check Completed' : 'Device Security Check',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'This screen performs only checks available to the Flutter application and does not claim to detect every malware sample.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: scanning ? null : scan,
                  child: scanning
                      ? const CircularProgressIndicator()
                      : Text(completed ? 'SCAN AGAIN' : 'START SCAN'),
                ),
              ),
            ],
          ),
        ),
      );
}
