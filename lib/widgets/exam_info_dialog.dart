import 'package:flutter/material.dart';

/// Modal dialog providing examination and viva reference information.
class ExamInfoDialog extends StatelessWidget {
  const ExamInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'College UI Flutter Lab Examination',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'External Examination & Viva Reference',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 14),

                // Formulas section
                _buildSectionHeader('1. MATHEMATICAL FORMULAS', Icons.functions_rounded),
                const SizedBox(height: 8),
                _buildFormulaCard(
                  'Body Mass Index (BMI)',
                  'BMI = Weight (kg) / [Height (m)]²',
                  'Example: Height = 170 cm (1.70 m), Weight = 70 kg\nBMI = 70 / (1.70 × 1.70) = 24.22 → 24.2 (Normal)',
                  isDark,
                ),
                const SizedBox(height: 8),
                _buildFormulaCard(
                  'Healthy Weight Range',
                  'Min Weight = 18.5 × [Height (m)]²\nMax Weight = 24.9 × [Height (m)]²',
                  'Example for 170 cm: 18.5 × 2.89 = 53.5 kg, 24.9 × 2.89 = 72.0 kg',
                  isDark,
                ),

                const SizedBox(height: 16),

                // WHO Categories
                _buildSectionHeader('2. WHO ADULT BMI CATEGORIES', Icons.category_rounded),
                const SizedBox(height: 8),
                Table(
                  border: TableBorder.all(
                    color: isDark ? Colors.blueGrey[800]! : Colors.blueGrey[200]!,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  children: const [
                    TableRow(
                      decoration: BoxDecoration(color: Color(0x1F808080)),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('BMI Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Risk Assessment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Underweight', style: TextStyle(color: Color(0xFF0288D1), fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('< 18.5', style: TextStyle(fontSize: 12)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Nutritional deficiency risk', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Normal Weight', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('18.5 – 24.9', style: TextStyle(fontSize: 12)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Lowest clinical health risk', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Overweight', style: TextStyle(color: Color(0xFFF57C00), fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('25.0 – 29.9', style: TextStyle(fontSize: 12)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Elevated risk of CVD/diabetes', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Obesity', style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('≥ 30.0', style: TextStyle(fontSize: 12)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('High risk, medical guidance advised', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Architecture and Tech Stack
                _buildSectionHeader('3. ARCHITECTURE & IMPLEMENTATION', Icons.memory_rounded),
                const SizedBox(height: 8),
                Text(
                  '• Framework: Flutter Web 3.47.9 (Material Design 3)\n'
                  '• State Management: Stateful Widget Architecture (exam-friendly, clean & explainable)\n'
                  '• Local Storage: Browser LocalStorage via shared_preferences\n'
                  '• UI Components: Responsive LayoutBuilder, Custom Animated Canvas Gauge, Preset Tester\n'
                  '• Deployment: GitHub Pages via GitHub Actions CI/CD automation',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark ? Colors.blueGrey[200] : Colors.blueGrey[800],
                  ),
                ),

                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close Dialog'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildFormulaCard(String title, String formula, String example, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.blueGrey[800]! : Colors.blueGrey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          SelectableText(
            formula,
            style: const TextStyle(
              fontSize: 12.5,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            example,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[600],
            ),
          ),
        ],
      ),
    );
  }
}
