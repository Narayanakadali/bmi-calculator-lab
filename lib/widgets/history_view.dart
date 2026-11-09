import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bmi_record.dart';
import 'category_badge.dart';

/// Displays locally stored calculation history with options to reload,
/// delete single items, or clear entire history.
class HistoryView extends StatelessWidget {
  final List<BmiRecord> records;
  final void Function(BmiRecord record) onSelectRecord;
  final void Function(String id) onDeleteRecord;
  final VoidCallback onClearHistory;

  const HistoryView({
    super.key,
    required this.records,
    required this.onSelectRecord,
    required this.onDeleteRecord,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateFormat = DateFormat('MMM d, yyyy • hh:mm a');

    if (records.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.blueGrey[800]! : Colors.blueGrey[200]!,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                size: 42,
                color: isDark ? Colors.blueGrey[600] : Colors.blueGrey[300],
              ),
              const SizedBox(height: 12),
              Text(
                'No Calculation History Yet',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Calculate a BMI above to start tracking records locally.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.blueGrey[500] : Colors.blueGrey[400],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.blueGrey[800]! : Colors.blueGrey[200]!,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with count & Clear All button
          Row(
            children: [
              Icon(
                Icons.history_rounded,
                size: 20,
                color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[700],
              ),
              const SizedBox(width: 8),
              Text(
                'CALCULATION HISTORY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[700],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blueGrey[800] : Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${records.length}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.blueGrey[200] : Colors.blueGrey[800],
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _confirmClearHistory(context),
                icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Scrollable list of history records
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final record = records[index];

              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onSelectRecord(record),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A).withValues(alpha: 0.6)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? Colors.blueGrey[800]!
                          : Colors.blueGrey[200]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      // BMI circle
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: record.category.surfaceColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: record.category.color,
                            width: 1.8,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            record.bmi.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: record.category.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Height, Weight, Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Text(
                                  '${record.heightCm.toStringAsFixed(0)} cm • ${record.weightKg.toStringAsFixed(1)} kg',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.blueGrey[900],
                                  ),
                                ),
                                CategoryBadge(category: record.category),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateFormat.format(record.timestamp),
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[500],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Delete single record button
                      IconButton(
                        tooltip: 'Delete this record',
                        icon: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[400],
                        ),
                        onPressed: () => onDeleteRecord(record.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Clear BMI History?'),
          content: const Text(
            'This will permanently delete all previously saved BMI calculations from your browser storage.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                onClearHistory();
              },
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }
}
