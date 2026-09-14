import 'package:flutter/material.dart';
import '../models/scan_result.dart';
import '../services/storage_service.dart';
import '../services/url_scanner_service.dart';
import '../utils/validators.dart';
import '../widgets/scan_button.dart';
import '../widgets/scan_result_card.dart';

class UrlScannerScreen extends StatefulWidget {
  const UrlScannerScreen({super.key});

  @override
  State<UrlScannerScreen> createState() => _UrlScannerScreenState();
}

class _UrlScannerScreenState extends State<UrlScannerScreen> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ScanResultModel? result;
  bool loading = false;

  Future<void> scan() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    setState(() {
      loading = true;
      result = null;
    });

    try {
      final value = await UrlScannerService.scanUrl(controller.text);
      await StorageService.saveScan(value);
      if (mounted) setState(() => result = value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('URL Security Scanner')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                validator: Validators.url,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Enter URL',
                  hintText: 'example.com',
                  prefixIcon: Icon(Icons.link),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ScanButton(text: 'SCAN URL', loading: loading, onPressed: scan),
            const SizedBox(height: 24),
            if (loading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Analyzing with VirusTotal...'),
                  ],
                ),
              ),
            if (result != null) ScanResultCard(result: result!),
          ],
        ),
      );
}
