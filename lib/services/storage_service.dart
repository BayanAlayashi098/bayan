import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_result.dart';

class StorageService {
  static const _key = 'scan_history';

  static Future<void> saveScan(ScanResultModel result) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.insert(0, jsonEncode(result.toJson()));
    if (list.length > 50) list.removeRange(50, list.length);
    await prefs.setStringList(_key, list);
  }

  static Future<List<ScanResultModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list
        .map((e) => ScanResultModel.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
