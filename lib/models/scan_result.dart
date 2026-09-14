enum ScanStatus { safe, suspicious, malicious, unknown }

class ScanResultModel {
  final String id;
  final String url;
  final String domain;
  final String ipAddress;
  final ScanStatus status;
  final int securityScore;
  final int totalEngines;
  final int maliciousCount;
  final DateTime scanTime;

  const ScanResultModel({
    required this.id,
    required this.url,
    required this.domain,
    required this.ipAddress,
    required this.status,
    required this.securityScore,
    required this.totalEngines,
    required this.maliciousCount,
    required this.scanTime,
  });

  String get statusLabel => switch (status) {
        ScanStatus.safe => 'SAFE',
        ScanStatus.suspicious => 'SUSPICIOUS',
        ScanStatus.malicious => 'MALICIOUS',
        ScanStatus.unknown => 'UNKNOWN',
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'domain': domain,
        'ipAddress': ipAddress,
        'status': status.name,
        'securityScore': securityScore,
        'totalEngines': totalEngines,
        'maliciousCount': maliciousCount,
        'scanTime': scanTime.toIso8601String(),
      };

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      id: json['id'] as String,
      url: json['url'] as String,
      domain: json['domain'] as String,
      ipAddress: json['ipAddress'] as String? ?? 'Not available',
      status: ScanStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ScanStatus.unknown,
      ),
      securityScore: (json['securityScore'] as num?)?.toInt() ?? 0,
      totalEngines: (json['totalEngines'] as num?)?.toInt() ?? 0,
      maliciousCount: (json['maliciousCount'] as num?)?.toInt() ?? 0,
      scanTime: DateTime.tryParse(json['scanTime'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
