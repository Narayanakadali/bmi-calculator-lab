import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmi_calculator/main.dart';
import 'package:bmi_calculator/models/bmi_category.dart';
import 'package:bmi_calculator/services/bmi_calculator_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('BMI Calculator Unit Tests', () {
    test('Calculates BMI accurately and rounds to 1 decimal place', () {
      // Height: 170 cm, Weight: 70 kg -> BMI = 70 / (1.70 * 1.70) = 24.22 -> 24.2
      final bmi1 = BmiCalculatorService.calculateBmi(weightKg: 70, heightCm: 170);
      expect(bmi1, equals(24.2));

      // Underweight test: 175 cm, 50 kg -> BMI = 50 / (1.75 * 1.75) = 16.32 -> 16.3
      final bmi2 = BmiCalculatorService.calculateBmi(weightKg: 50, heightCm: 175);
      expect(bmi2, equals(16.3));

      // Overweight test: 170 cm, 78 kg -> BMI = 78 / (1.70 * 1.70) = 26.98 -> 27.0
      final bmi3 = BmiCalculatorService.calculateBmi(weightKg: 78, heightCm: 170);
      expect(bmi3, equals(27.0));

      // Obesity test: 160 cm, 85 kg -> BMI = 85 / (1.60 * 1.60) = 33.2
      final bmi4 = BmiCalculatorService.calculateBmi(weightKg: 85, heightCm: 160);
      expect(bmi4, equals(33.2));
    });

    test('Classifies BMI categories according to WHO standards', () {
      expect(BmiCategory.fromBmi(16.0), equals(BmiCategory.underweight));
      expect(BmiCategory.fromBmi(18.4), equals(BmiCategory.underweight));
      expect(BmiCategory.fromBmi(18.5), equals(BmiCategory.normal));
      expect(BmiCategory.fromBmi(24.9), equals(BmiCategory.normal));
      expect(BmiCategory.fromBmi(25.0), equals(BmiCategory.overweight));
      expect(BmiCategory.fromBmi(29.9), equals(BmiCategory.overweight));
      expect(BmiCategory.fromBmi(30.0), equals(BmiCategory.obesity));
      expect(BmiCategory.fromBmi(35.5), equals(BmiCategory.obesity));
    });

    test('Calculates healthy weight range correctly', () {
      final range = BmiCalculatorService.calculateHealthyWeightRange(170);
      // Min: 18.5 * 1.70^2 = 53.465 -> 53.5
      // Max: 24.9 * 1.70^2 = 71.961 -> 72.0
      expect(range.minWeightKg, equals(53.5));
      expect(range.maxWeightKg, equals(72.0));
    });

    test('Validates height inputs correctly', () {
      expect(BmiCalculatorService.validateHeight(null), isNotNull);
      expect(BmiCalculatorService.validateHeight(''), isNotNull);
      expect(BmiCalculatorService.validateHeight('abc'), isNotNull);
      expect(BmiCalculatorService.validateHeight('0'), isNotNull);
      expect(BmiCalculatorService.validateHeight('-10'), isNotNull);
      expect(BmiCalculatorService.validateHeight('30'), isNotNull); // below realistic 50 cm
      expect(BmiCalculatorService.validateHeight('350'), isNotNull); // above realistic 260 cm
      expect(BmiCalculatorService.validateHeight('170'), isNull); // valid
    });

    test('Validates weight inputs correctly', () {
      expect(BmiCalculatorService.validateWeight(null), isNotNull);
      expect(BmiCalculatorService.validateWeight(''), isNotNull);
      expect(BmiCalculatorService.validateWeight('xyz'), isNotNull);
      expect(BmiCalculatorService.validateWeight('0'), isNotNull);
      expect(BmiCalculatorService.validateWeight('-5'), isNotNull);
      expect(BmiCalculatorService.validateWeight('5'), isNotNull); // below realistic 10 kg
      expect(BmiCalculatorService.validateWeight('450'), isNotNull); // above realistic 400 kg
      expect(BmiCalculatorService.validateWeight('70.5'), isNull); // valid
    });
  });

  group('BMI Health App UI Widget Tests', () {
    testWidgets('Renders all essential UI components and calculates BMI', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 960);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const BmiHealthApp());
      await tester.pumpAndSettle();

      // Verify Title
      expect(find.text('BMI & Health Calculator'), findsOneWidget);

      // Verify Input Labels
      expect(find.text('Height (Centimeters)'), findsOneWidget);
      expect(find.text('Weight (Kilograms)'), findsOneWidget);

      // Verify Calculate and Reset buttons
      expect(find.text('Calculate BMI'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);

      // Verify initial calculated result is displayed (170cm, 70kg -> 24.2)
      expect(find.text('24.2'), findsWidgets);
      expect(find.text('Normal Weight'), findsWidgets);

      // Tap Reset button
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      // Result should be cleared and ready screen shown
      expect(find.text('Ready to Calculate'), findsOneWidget);
    });
  });
}
