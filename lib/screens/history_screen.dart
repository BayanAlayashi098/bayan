import 'package:flutter/material.dart';
import '../models/scan_result.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<ScanResultModel>> history;

  @override
  void initState() {
    super.initState();
    history = StorageService.getHistory();
  }

  Future<void> clear() async {
    await StorageService.clearHistory();
    setState(() => history = StorageService.getHistory());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Scan History'),
          actions: [
            IconButton(onPressed: clear, icon: const Icon(Icons.delete_outline)),
          ],
        ),
        body: FutureBuilder<List<ScanResultModel>>(
          future: history,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = snapshot.data!;
            if (items.isEmpty) {
              return const Center(child: Text('No scans yet.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      item.status == ScanStatus.malicious
                          ? Icons.warning
                          : Icons.verified,
                    ),
                    title: Text(item.domain),
                    subtitle: Text(item.statusLabel),
                    trailing: Text('${item.securityScore}%'),
                  ),
                );
              },
            );
          },
        ),
      );
}
