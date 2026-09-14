import 'package:flutter/material.dart';
import '../models/scan_result.dart';
import '../utils/app_colors.dart';

class ScanResultCard extends StatelessWidget {
  final ScanResultModel result;

  const ScanResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final color = switch (result.status) {
      ScanStatus.safe => AppColors.neonGreen,
      ScanStatus.suspicious => AppColors.orange,
      ScanStatus.malicious => AppColors.red,
      ScanStatus.unknown => AppColors.muted,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.statusLabel,
                    style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Text('${result.securityScore}%',
                    style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _row('Domain', result.domain),
            _row('Engines', '${result.totalEngines}'),
            _row('Malicious', '${result.maliciousCount}'),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Text(title, style: const TextStyle(color: AppColors.muted)),
            const Spacer(),
            Flexible(child: Text(value, textAlign: TextAlign.right)),
          ],
        ),
      );
}
