import 'bmi_category.dart';

/// Represents a single historical BMI calculation record.
class BmiRecord {
  final String id;
  final double heightCm;
  final double weightKg;
  final double bmi;
  final BmiCategory category;
  final DateTime timestamp;
  final String? gender;
  final int? age;

  const BmiRecord({
    required this.id,
    required this.heightCm,
    required this.weightKg,
    required this.bmi,
    required this.category,
    required this.timestamp,
    this.gender,
    this.age,
  });

  /// Serializes the record to a JSON Map for persistent local storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'bmi': bmi,
      'category': category.name,
      'timestamp': timestamp.toIso8601String(),
      'gender': gender,
      'age': age,
    };
  }

  /// Deserializes a JSON Map into a BmiRecord instance.
  factory BmiRecord.fromJson(Map<String, dynamic> json) {
    final categoryName = json['category'] as String? ?? 'normal';
    final category = BmiCategory.values.firstWhere(
      (e) => e.name == categoryName,
      orElse: () => BmiCategory.normal,
    );

    return BmiRecord(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      heightCm: (json['heightCm'] as num).toDouble(),
      weightKg: (json['weightKg'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      category: category,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      gender: json['gender'] as String?,
      age: json['age'] as int?,
    );
  }
}
