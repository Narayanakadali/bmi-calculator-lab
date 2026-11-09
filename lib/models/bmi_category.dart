import 'package:flutter/material.dart';

/// Enum representing the standard World Health Organization (WHO)
/// adult Body Mass Index (BMI) categories.
enum BmiCategory {
  underweight,
  normal,
  overweight,
  obesity;

  /// Determines the category based on the calculated BMI value.
  static BmiCategory fromBmi(double bmi) {
    if (bmi < 18.5) {
      return BmiCategory.underweight;
    } else if (bmi < 25.0) {
      return BmiCategory.normal;
    } else if (bmi < 30.0) {
      return BmiCategory.overweight;
    } else {
      return BmiCategory.obesity;
    }
  }

  /// Human-readable title of the category.
  String get label {
    switch (this) {
      case BmiCategory.underweight:
        return 'Underweight';
      case BmiCategory.normal:
        return 'Normal Weight';
      case BmiCategory.overweight:
        return 'Overweight';
      case BmiCategory.obesity:
        return 'Obesity';
    }
  }

  /// Threshold description according to WHO guidelines.
  String get rangeDescription {
    switch (this) {
      case BmiCategory.underweight:
        return 'BMI < 18.5';
      case BmiCategory.normal:
        return 'BMI 18.5 – 24.9';
      case BmiCategory.overweight:
        return 'BMI 25.0 – 29.9';
      case BmiCategory.obesity:
        return 'BMI ≥ 30.0';
    }
  }

  /// Primary color associated with the classification.
  Color get color {
    switch (this) {
      case BmiCategory.underweight:
        return const Color(0xFF0288D1); // Blue
      case BmiCategory.normal:
        return const Color(0xFF2E7D32); // Emerald Green
      case BmiCategory.overweight:
        return const Color(0xFFF57C00); // Amber / Orange
      case BmiCategory.obesity:
        return const Color(0xFFD32F2F); // Crimson Red
    }
  }

  /// Background / surface tint color with subtle opacity.
  Color get surfaceColor {
    return color.withValues(alpha: 0.12);
  }

  /// Border color for cards and chips.
  Color get borderColor {
    return color.withValues(alpha: 0.35);
  }

  /// Icon representative of this category.
  IconData get icon {
    switch (this) {
      case BmiCategory.underweight:
        return Icons.trending_down_rounded;
      case BmiCategory.normal:
        return Icons.verified_rounded;
      case BmiCategory.overweight:
        return Icons.trending_up_rounded;
      case BmiCategory.obesity:
        return Icons.warning_amber_rounded;
    }
  }

  /// Summary recommendation for the user.
  String get summaryAdvice {
    switch (this) {
      case BmiCategory.underweight:
        return 'Your BMI indicates you may be underweight. Focus on calorie-dense, nutrient-rich foods and resistance training.';
      case BmiCategory.normal:
        return 'Congratulations! Your BMI is within the healthy range. Maintain your balanced lifestyle and regular physical activity.';
      case BmiCategory.overweight:
        return 'Your BMI is slightly above the healthy threshold. Adopting portion control and incorporating daily aerobic exercise is recommended.';
      case BmiCategory.obesity:
        return 'Your BMI falls into the obesity category. A structured lifestyle approach with professional healthcare guidance is recommended.';
    }
  }

  /// Nutritional guidance points.
  List<String> get nutritionTips {
    switch (this) {
      case BmiCategory.underweight:
        return [
          'Incorporate healthy fats: nuts, seeds, avocados, and whole grains.',
          'Eat smaller, frequent meals throughout the day with adequate protein.',
          'Add nutrient-rich smoothies or milkshakes between meals.',
        ];
      case BmiCategory.normal:
        return [
          'Eat a rainbow of vegetables, fruits, and lean proteins daily.',
          'Stay adequately hydrated with 2 to 3 liters of water per day.',
          'Limit ultra-processed foods, excess sodium, and refined sugars.',
        ];
      case BmiCategory.overweight:
        return [
          'Practice mindful eating and reduce refined sugar and soda intake.',
          'Increase dietary fiber through pulses, vegetables, and oats.',
          'Use smaller plates to naturally regulate portion sizes.',
        ];
      case BmiCategory.obesity:
        return [
          'Consult a registered dietitian for a personalized nutrition plan.',
          'Replace sugary beverages and juices with pure water or herbal teas.',
          'Focus on whole, unprocessed foods and avoid empty calorie snacks.',
        ];
    }
  }

  /// Physical activity guidance points.
  List<String> get activityTips {
    switch (this) {
      case BmiCategory.underweight:
        return [
          'Prioritize resistance/strength training to build lean muscle mass.',
          'Limit excessive cardio that may burn needed calories.',
          'Ensure sufficient rest and 7-9 hours of restorative sleep.',
        ];
      case BmiCategory.normal:
        return [
          'Aim for at least 150 minutes of moderate aerobic exercise weekly.',
          'Include 2 sessions of strength training per week for bone density.',
          'Maintain active daily habits such as brisk walking and stretching.',
        ];
      case BmiCategory.overweight:
        return [
          'Engage in 45-60 minutes of brisk walking, swimming, or cycling daily.',
          'Gradually incorporate interval training (HIIT) 2-3 times weekly.',
          'Track daily step count with a goal of 8,000–10,000 steps.',
        ];
      case BmiCategory.obesity:
        return [
          'Start with low-impact joint-friendly exercises like swimming or walking.',
          'Break exercise into manageable 10-15 minute sessions twice a day.',
          'Seek medical clearance before starting vigorous new routines.',
        ];
    }
  }
}
