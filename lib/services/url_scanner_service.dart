import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scan_result.dart';

class UrlScannerService {
  static const String _apiKey = 'PUT_YOUR_VIRUSTOTAL_API_KEY_HERE';
  static const String _baseUrl = 'https://www.virustotal.com/api/v3';

  static String _encodeUrl(String url) =>
      base64UrlEncode(utf8.encode(url)).replaceAll('=', '');

  static Future<ScanResultModel> scanUrl(String targetUrl) async {
    if (_apiKey.isEmpty ||
        _apiKey == 'PUT_YOUR_VIRUSTOTAL_API_KEY_HERE') {
      throw Exception('Add your VirusTotal API key first.');
    }

    var formattedUrl = targetUrl.trim();
    if (formattedUrl.isEmpty) {
      throw Exception('Please enter a URL.');
    }

    if (!formattedUrl.startsWith('http://') &&
        !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }

    final uri = Uri.tryParse(formattedUrl);
    if (uri == null || uri.host.isEmpty) {
      throw Exception('Invalid URL.');
    }

    final headers = {
      'x-apikey': _apiKey,
      'Accept': 'application/json',
    };

    final submit = await http.post(
      Uri.parse('$_baseUrl/urls'),
      headers: {
        ...headers,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'url': formattedUrl},
    );

    if (submit.statusCode != 200 && submit.statusCode != 201) {
      _apiError(submit.statusCode);
    }

    final submitJson = jsonDecode(submit.body) as Map<String, dynamic>;
    final analysisId =
        (submitJson['data'] as Map<String, dynamic>)['id'] as String;

    Map<String, dynamic>? analysisAttributes;

    for (var i = 0; i < 15; i++) {
      await Future.delayed(const Duration(seconds: 2));

      final response = await http.get(
        Uri.parse('$_baseUrl/analyses/$analysisId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        _apiError(response.statusCode);
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>;
      final attributes = data['attributes'] as Map<String, dynamic>;

      if (attributes['status'] == 'completed') {
        analysisAttributes = attributes;
        break;
      }
    }

    if (analysisAttributes == null) {
      throw Exception('Analysis is still running. Please try again later.');
    }

    final stats = (analysisAttributes['stats'] as Map<String, dynamic>?) ??
        <String, dynamic>{};

    final malicious = (stats['malicious'] as num?)?.toInt() ?? 0;
    final suspicious = (stats['suspicious'] as num?)?.toInt() ?? 0;
    final harmless = (stats['harmless'] as num?)?.toInt() ?? 0;
    final undetected = (stats['undetected'] as num?)?.toInt() ?? 0;
    final total = malicious + suspicious + harmless + undetected;

    final status = malicious > 0
        ? ScanStatus.malicious
        : suspicious > 0
            ? ScanStatus.suspicious
            : harmless > 0
                ? ScanStatus.safe
                : ScanStatus.unknown;

    final score = total == 0
        ? 0
        : (((total - (malicious * 2) - suspicious) / total) * 100)
            .clamp(0, 100)
            .round();

    return ScanResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: formattedUrl,
      domain: uri.host,
      ipAddress: 'Not available',
      status: status,
      securityScore: score,
      totalEngines: total,
      maliciousCount: malicious,
      scanTime: DateTime.now(),
    );
  }

  static Never _apiError(int code) {
    if (code == 400) throw Exception('Invalid VirusTotal request.');
    if (code == 401) throw Exception('Invalid VirusTotal API key.');
    if (code == 403) throw Exception('VirusTotal access is forbidden.');
    if (code == 404) throw Exception('Resource not found.');
    if (code == 429) throw Exception('VirusTotal rate limit exceeded.');
    if (code >= 500) throw Exception('VirusTotal server error.');
    throw Exception('VirusTotal request failed: $code');
  }
}
