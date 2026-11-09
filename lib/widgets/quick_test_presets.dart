import 'package:flutter/material.dart';
import '../models/bmi_category.dart';

/// Preset scenario definition for quick laboratory testing.
class PresetScenario {
  final String title;
  final double heightCm;
  final double weightKg;
  final String expectedBmi;
  final BmiCategory category;

  const PresetScenario({
    required this.title,
    required this.heightCm,
    required this.weightKg,
    required this.expectedBmi,
    required this.category,
  });
}

/// A collection of one-click test cases for fast viva examination demonstrations.
class QuickTestPresets extends StatelessWidget {
  final void Function(double heightCm, double weightKg) onSelectPreset;

  const QuickTestPresets({
    super.key,
    required this.onSelectPreset,
  });

  static const List<PresetScenario> presets = [
    PresetScenario(
      title: 'Underweight',
      heightCm: 175,
      weightKg: 50,
      expectedBmi: '16.3',
      category: BmiCategory.underweight,
    ),
    PresetScenario(
      title: 'Normal',
      heightCm: 170,
      weightKg: 65,
      expectedBmi: '22.5',
      category: BmiCategory.normal,
    ),
    PresetScenario(
      title: 'Overweight',
      heightCm: 170,
      weightKg: 78,
      expectedBmi: '27.0',
      category: BmiCategory.overweight,
    ),
    PresetScenario(
      title: 'Obesity',
      heightCm: 160,
      weightKg: 85,
      expectedBmi: '33.2',
      category: BmiCategory.obesity,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on_rounded,
              size: 16,
              color: isDark ? Colors.amberAccent : Colors.amber[800],
            ),
            const SizedBox(width: 6),
            Text(
              'QUICK EXAM TEST PRESETS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[700],
              ),
            ),
            const Spacer(),
            Text(
              '1-Tap Viva Demo',
              style: TextStyle(
                fontSize: 10.5,
                color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[500],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presets.map((scenario) {
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => onSelectPreset(scenario.heightCm, scenario.weightKg),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: scenario.category.surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: scenario.category.borderColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: scenario.category.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${scenario.title} (${scenario.heightCm.toInt()}cm, ${scenario.weightKg.toInt()}kg)',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.blueGrey[900],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
