import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_record.dart';

/// Local storage service managing BMI calculation history
/// using browser LocalStorage via the shared_preferences package.
class StorageService {
  static const String _historyKey = 'bmi_calculation_history_v1';
  static const int _maxHistoryItems = 30;

  /// Retrieves the history of BMI calculations, newest first.
  static Future<List<BmiRecord>> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? rawJson = prefs.getString(_historyKey);
      if (rawJson == null || rawJson.trim().isEmpty) {
        return [];
      }

      final List<dynamic> decodedList = jsonDecode(rawJson) as List<dynamic>;
      return decodedList
          .map((item) => BmiRecord.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // In case of parsing error, return empty list gracefully
      return [];
    }
  }

  /// Adds a new BMI record to the top of the history list and persists it.
  static Future<List<BmiRecord>> saveRecord(BmiRecord record) async {
    final List<BmiRecord> current = await loadHistory();
    // Insert at front
    current.insert(0, record);

    // Limit to maximum history items to preserve local storage limits
    if (current.length > _maxHistoryItems) {
      current.removeRange(_maxHistoryItems, current.length);
    }

    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(current.map((r) => r.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
    return current;
  }

  /// Deletes a specific record by its unique ID.
  static Future<List<BmiRecord>> deleteRecord(String id) async {
    final List<BmiRecord> current = await loadHistory();
    current.removeWhere((record) => record.id == id);

    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(current.map((r) => r.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
    return current;
  }

  /// Clears all stored BMI history records.
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
