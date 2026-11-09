import 'dart:math' as math;

/// Pure calculation and validation service for BMI operations.
/// Encapsulates formulas, validation rules, and healthy weight range logic.
class BmiCalculatorService {
  /// Realistic minimum and maximum bounds for validation.
  static const double minRealisticHeightCm = 50.0;
  static const double maxRealisticHeightCm = 260.0;
  static const double minRealisticWeightKg = 10.0;
  static const double maxRealisticWeightKg = 400.0;

  /// Calculates BMI given weight in kilograms and height in centimeters.
  /// Formula: BMI = Weight (kg) / (Height (m) * Height (m))
  /// Returns the BMI rounded to 1 decimal place.
  static double calculateBmi({
    required double weightKg,
    required double heightCm,
  }) {
    if (heightCm <= 0 || weightKg <= 0) {
      throw ArgumentError('Height and weight must be strictly positive numbers.');
    }
    final double heightMeters = heightCm / 100.0;
    final double rawBmi = weightKg / (heightMeters * heightMeters);
    return roundToOneDecimal(rawBmi);
  }

  /// Helper to round any double to exactly one decimal place.
  static double roundToOneDecimal(double value) {
    return (value * 10).round() / 10.0;
  }

  /// Calculates the estimated healthy weight range (kg) for a given height (cm).
  /// Minimum healthy weight = 18.5 * height in meters²
  /// Maximum healthy weight = 24.9 * height in meters²
  static ({double minWeightKg, double maxWeightKg}) calculateHealthyWeightRange(
    double heightCm,
  ) {
    final double heightMeters = heightCm / 100.0;
    final double heightSquared = heightMeters * heightMeters;
    final double minWeight = 18.5 * heightSquared;
    final double maxWeight = 24.9 * heightSquared;

    return (
      minWeightKg: roundToOneDecimal(minWeight),
      maxWeightKg: roundToOneDecimal(maxWeight),
    );
  }

  /// Computes the difference between the current weight and the healthy range.
  static ({double differenceKg, String statusMessage}) analyzeWeightDifference({
    required double weightKg,
    required double heightCm,
  }) {
    final range = calculateHealthyWeightRange(heightCm);

    if (weightKg < range.minWeightKg) {
      final double diff = roundToOneDecimal(range.minWeightKg - weightKg);
      return (
        differenceKg: diff,
        statusMessage: '$diff kg below minimum healthy weight',
      );
    } else if (weightKg > range.maxWeightKg) {
      final double diff = roundToOneDecimal(weightKg - range.maxWeightKg);
      return (
        differenceKg: diff,
        statusMessage: '$diff kg above maximum healthy weight',
      );
    } else {
      return (
        differenceKg: 0.0,
        statusMessage: 'Currently in ideal healthy weight range',
      );
    }
  }

  /// Validates the height input string.
  /// Handles: empty, non-numeric, zero, negative, and unrealistic values.
  static String? validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your height in centimeters.';
    }

    final trimmed = value.trim();
    final double? parsed = double.tryParse(trimmed);

    if (parsed == null) {
      return 'Invalid entry: height must be a valid number.';
    }

    if (parsed <= 0) {
      return 'Height must be greater than zero.';
    }

    if (parsed < minRealisticHeightCm) {
      return 'Unrealistic height: must be at least $minRealisticHeightCm cm.';
    }

    if (parsed > maxRealisticHeightCm) {
      return 'Unrealistic height: must not exceed $maxRealisticHeightCm cm.';
    }

    return null;
  }

  /// Validates the weight input string.
  /// Handles: empty, non-numeric, zero, negative, and unrealistic values.
  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your weight in kilograms.';
    }

    final trimmed = value.trim();
    final double? parsed = double.tryParse(trimmed);

    if (parsed == null) {
      return 'Invalid entry: weight must be a valid number.';
    }

    if (parsed <= 0) {
      return 'Weight must be greater than zero.';
    }

    if (parsed < minRealisticWeightKg) {
      return 'Unrealistic weight: must be at least $minRealisticWeightKg kg.';
    }

    if (parsed > maxRealisticWeightKg) {
      return 'Unrealistic weight: must not exceed $maxRealisticWeightKg kg.';
    }

    return null;
  }

  /// Converts Imperial feet and inches to metric centimeters.
  static double feetAndInchesToCm(int feet, double inches) {
    return (feet * 30.48) + (inches * 2.54);
  }

  /// Converts metric centimeters to feet and inches tuple.
  static ({int feet, double inches}) cmToFeetAndInches(double cm) {
    final double totalInches = cm / 2.54;
    final int feet = (totalInches / 12).floor();
    final double inches = roundToOneDecimal(totalInches % 12);
    return (feet: feet, inches: inches);
  }

  /// Computes the visual gauge percentage (0.0 to 1.0) on a 15 to 40 scale.
  /// Scale intervals:
  /// [15.0 - 18.5] -> 20% of width (Underweight)
  /// [18.5 - 25.0] -> 35% of width (Normal)
  /// [25.0 - 30.0] -> 25% of width (Overweight)
  /// [30.0 - 40.0] -> 20% of width (Obesity)
  static double calculateGaugePosition(double bmi) {
    final double clamped = bmi.clamp(15.0, 40.0);

    if (clamped <= 18.5) {
      // 15.0 to 18.5 mapped to 0.0 -> 0.20
      final double fraction = (clamped - 15.0) / (18.5 - 15.0);
      return math.max(0.02, fraction * 0.20);
    } else if (clamped <= 25.0) {
      // 18.5 to 25.0 mapped to 0.20 -> 0.55
      final double fraction = (clamped - 18.5) / (25.0 - 18.5);
      return 0.20 + (fraction * 0.35);
    } else if (clamped <= 30.0) {
      // 25.0 to 30.0 mapped to 0.55 -> 0.80
      final double fraction = (clamped - 25.0) / (30.0 - 25.0);
      return 0.55 + (fraction * 0.25);
    } else {
      // 30.0 to 40.0 mapped to 0.80 -> 1.00
      final double fraction = (clamped - 30.0) / (40.0 - 30.0);
      return math.min(0.98, 0.80 + (fraction * 0.20));
    }
  }
}
