import 'package:flutter/material.dart';
import '../models/bmi_category.dart';
import '../services/bmi_calculator_service.dart';

/// A mathematically accurate, animated visual BMI progress scale / gauge.
/// Displays Underweight, Normal, Overweight, and Obesity ranges with
/// an animated pointer indicating the user's current BMI location.
class BmiGauge extends StatelessWidget {
  final double? bmi;
  final BmiCategory? category;

  const BmiGauge({
    super.key,
    required this.bmi,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double targetPercent = bmi != null
        ? BmiCalculatorService.calculateGaugePosition(bmi!)
        : 0.35; // default position in normal range if uncalculated

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'BMI VISUAL SCALE',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: isDark ? Colors.blueGrey[200] : Colors.blueGrey[700],
              ),
            ),
            if (bmi != null)
              Text(
                'Position: ${bmi!.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: category?.color ?? theme.colorScheme.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 28),

        // Indicator and Bar Stack
        LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.35, end: targetPercent),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, currentPercent, child) {
                // Pin pointer position within track bounds
                final double pointerX = (currentPercent * width).clamp(24.0, width - 24.0);

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Segmented Gauge Bar
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          height: 16.0,
                          child: Row(
                            children: [
                              // Underweight segment (approx 20% of scale)
                              Expanded(
                                flex: 20,
                                child: Container(
                                  color: const Color(0xFF0288D1),
                                ),
                              ),
                              const SizedBox(width: 2),
                              // Normal weight segment (approx 35% of scale)
                              Expanded(
                                flex: 35,
                                child: Container(
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(width: 2),
                              // Overweight segment (approx 25% of scale)
                              Expanded(
                                flex: 25,
                                child: Container(
                                  color: const Color(0xFFF57C00),
                                ),
                              ),
                              const SizedBox(width: 2),
                              // Obesity segment (approx 20% of scale)
                              Expanded(
                                flex: 20,
                                child: Container(
                                  color: const Color(0xFFD32F2F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Pointer Needle & Tag (Only when calculated)
                    if (bmi != null)
                      Positioned(
                        left: pointerX - 24.0,
                        top: -24.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: category?.color ?? theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                bmi!.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            CustomPaint(
                              size: const Size(10, 6),
                              painter: _TrianglePointerPainter(
                                color: category?.color ?? theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Small vertical pin dot
                            Container(
                              width: 3,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 2,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),

        const SizedBox(height: 10),

        // Scale numeric cutoff markers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMarkerText('15.0', isDark),
            _buildMarkerText('18.5', isDark),
            _buildMarkerText('25.0', isDark),
            _buildMarkerText('30.0', isDark),
            _buildMarkerText('40.0', isDark),
          ],
        ),

        const SizedBox(height: 20),

        // Responsive Category Legends
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _buildLegendItem(
              'Underweight',
              '< 18.5',
              const Color(0xFF0288D1),
              category == BmiCategory.underweight,
              isDark,
            ),
            _buildLegendItem(
              'Normal',
              '18.5 – 24.9',
              const Color(0xFF2E7D32),
              category == BmiCategory.normal,
              isDark,
            ),
            _buildLegendItem(
              'Overweight',
              '25.0 – 29.9',
              const Color(0xFFF57C00),
              category == BmiCategory.overweight,
              isDark,
            ),
            _buildLegendItem(
              'Obesity',
              '≥ 30.0',
              const Color(0xFFD32F2F),
              category == BmiCategory.obesity,
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarkerText(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[600],
      ),
    );
  }

  Widget _buildLegendItem(
    String label,
    String range,
    Color color,
    bool isCurrent,
    bool isDark,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isCurrent
            ? color.withValues(alpha: isDark ? 0.25 : 0.15)
            : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03)),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrent ? color : Colors.transparent,
          width: isCurrent ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
              color: isCurrent
                  ? color
                  : (isDark ? Colors.blueGrey[200] : Colors.blueGrey[800]),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            range,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePointerPainter extends CustomPainter {
  final Color color;

  const _TrianglePointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePointerPainter oldDelegate) =>
      oldDelegate.color != color;
}
