import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/security_card.dart';
import 'url_scanner_screen.dart';
import 'password_checker_screen.dart';
import 'system_scan_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Suite'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('SECURITY OVERVIEW',
              style: TextStyle(
                  color: AppColors.neonGreen,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.verified_user,
                      color: AppColors.neonGreen, size: 42),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                        'bayan suspicious links with VirusTotal and check password strength locally.'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SecurityCard(
            icon: Icons.link,
            title: 'URL Security Scanner',
            subtitle: 'Analyze links using VirusTotal',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const UrlScannerScreen())),
          ),
          const SizedBox(height: 14),
          SecurityCard(
            icon: Icons.password,
            title: 'Password Security Checker',
            subtitle: 'Check password strength locally',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PasswordCheckerScreen())),
          ),
          const SizedBox(height: 14),
          SecurityCard(
            icon: Icons.phone_android,
            title: 'System Security Scan',
            subtitle: 'Review basic application-level indicators',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SystemScanScreen())),
          ),
        ],
      ),
    );
  }
}
