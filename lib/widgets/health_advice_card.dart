import 'package:flutter/material.dart';
import '../models/bmi_category.dart';
import '../services/bmi_calculator_service.dart';

/// Card presenting calculated healthy weight range, weight difference analysis,
/// and tailored lifestyle recommendations for diet and physical activity.
class HealthAdviceCard extends StatelessWidget {
  final double heightCm;
  final double weightKg;
  final BmiCategory category;

  const HealthAdviceCard({
    super.key,
    required this.heightCm,
    required this.weightKg,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final range = BmiCalculatorService.calculateHealthyWeightRange(heightCm);
    final analysis = BmiCalculatorService.analyzeWeightDifference(
      weightKg: weightKg,
      heightCm: heightCm,
    );

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.blueGrey[800]! : Colors.blueGrey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: category.surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  color: category.color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HEALTH & WEIGHT ANALYSIS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Personalized for ${heightCm.toStringAsFixed(0)} cm Height',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.blueGrey[900],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 18),

          // Healthy Weight Range Highlight Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.blueGrey[700]! : Colors.blueGrey[300]!,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.balance_rounded,
                            size: 16,
                            color: isDark ? Colors.tealAccent[400] : Colors.teal[700],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Estimated Healthy Weight Range',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${range.minWeightKg} kg – ${range.maxWeightKg} kg',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.tealAccent[100] : Colors.teal[900],
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Based on WHO normal BMI formula (18.5 – 24.9 × height²)',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Current Status Chip / Weight Delta
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: category.surfaceColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: category.borderColor,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  category.icon,
                  size: 18,
                  color: category.color,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    analysis.statusMessage,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: category.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Category Summary Text
          Text(
            category.summaryAdvice,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? Colors.blueGrey[200] : Colors.blueGrey[800],
            ),
          ),

          const SizedBox(height: 16),

          // Two-column or stacked recommendations
          _buildTipsSection(
            context,
            icon: Icons.restaurant_rounded,
            title: 'Dietary Recommendations',
            tips: category.nutritionTips,
            isDark: isDark,
          ),

          const SizedBox(height: 14),

          _buildTipsSection(
            context,
            icon: Icons.directions_run_rounded,
            title: 'Physical Activity & Lifestyle',
            tips: category.activityTips,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<String> tips,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isDark ? Colors.lightBlueAccent[100] : Colors.blue[800],
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.blueGrey[900],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: category.color,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[700],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
