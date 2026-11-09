import 'package:flutter/material.dart';
import '../models/bmi_category.dart';

/// A modern Material 3 badge that displays the BMI category
/// with distinct theme colors and an icon.
class CategoryBadge extends StatelessWidget {
  final BmiCategory category;
  final bool large;

  const CategoryBadge({
    super.key,
    required this.category,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 16.0 : 10.0,
        vertical: large ? 8.0 : 4.0,
      ),
      decoration: BoxDecoration(
        color: category.surfaceColor,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: category.borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            category.icon,
            size: large ? 20.0 : 14.0,
            color: category.color,
          ),
          SizedBox(width: large ? 8.0 : 6.0),
          Text(
            category.label,
            style: TextStyle(
              color: category.color,
              fontWeight: FontWeight.w700,
              fontSize: large ? 14.0 : 12.0,
              letterSpacing: 0.3,
            ),
          ),
          if (large) ...[
            const SizedBox(width: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                category.rangeDescription,
                style: TextStyle(
                  color: category.color,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
