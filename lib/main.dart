import 'package:flutter/material.dart';
import 'models/bmi_category.dart';
import 'models/bmi_record.dart';
import 'services/bmi_calculator_service.dart';
import 'services/storage_service.dart';
import 'widgets/bmi_gauge.dart';
import 'widgets/category_badge.dart';
import 'widgets/health_advice_card.dart';
import 'widgets/history_view.dart';
import 'widgets/quick_test_presets.dart';
import 'widgets/exam_info_dialog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BmiHealthApp());
}

class BmiHealthApp extends StatefulWidget {
  const BmiHealthApp({super.key});

  @override
  State<BmiHealthApp> createState() => _BmiHealthAppState();
}

class _BmiHealthAppState extends State<BmiHealthApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color brandPrimary = Color(0xFF0284C7); // Sky Blue 600

    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPrimary,
        brightness: Brightness.light,
        surface: const Color(0xFFF8FAFC),
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      fontFamily: 'Segoe UI',
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPrimary,
        brightness: Brightness.dark,
        surface: const Color(0xFF1E293B),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      fontFamily: 'Segoe UI',
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );

    return MaterialApp(
      title: 'BMI & Health Calculator',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: BmiCalculatorHomePage(
        onToggleTheme: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class BmiCalculatorHomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const BmiCalculatorHomePage({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<BmiCalculatorHomePage> createState() => _BmiCalculatorHomePageState();
}

class _BmiCalculatorHomePageState extends State<BmiCalculatorHomePage> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _heightController = TextEditingController(text: '170');
  final TextEditingController _weightController = TextEditingController(text: '70');
  final TextEditingController _ageController = TextEditingController(text: '22');

  String _selectedGender = 'Male';

  // Calculation Results
  double? _calculatedBmi = 24.2;
  BmiCategory? _calculatedCategory = BmiCategory.normal;
  double? _lastHeight = 170.0;
  double? _lastWeight = 70.0;

  // History Records
  List<BmiRecord> _history = [];
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final records = await StorageService.loadHistory();
    setState(() {
      _history = records;
      _isLoadingHistory = false;
    });
  }

  void _calculateBmi() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct input errors before calculating.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final double height = double.parse(_heightController.text.trim());
    final double weight = double.parse(_weightController.text.trim());
    final int? age = int.tryParse(_ageController.text.trim());

    final double bmi = BmiCalculatorService.calculateBmi(
      weightKg: weight,
      heightCm: height,
    );
    final BmiCategory category = BmiCategory.fromBmi(bmi);

    final record = BmiRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      heightCm: height,
      weightKg: weight,
      bmi: bmi,
      category: category,
      timestamp: DateTime.now(),
      gender: _selectedGender,
      age: age,
    );

    setState(() {
      _calculatedBmi = bmi;
      _calculatedCategory = category;
      _lastHeight = height;
      _lastWeight = weight;
    });

    // Save locally
    StorageService.saveRecord(record).then((updatedList) {
      setState(() {
        _history = updatedList;
      });
    });
  }

  void _resetAll() {
    _formKey.currentState?.reset();
    setState(() {
      _heightController.clear();
      _weightController.clear();
      _ageController.text = '22';
      _selectedGender = 'Male';
      _calculatedBmi = null;
      _calculatedCategory = null;
      _lastHeight = null;
      _lastWeight = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inputs and calculation results reset successfully.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _loadPreset(double heightCm, double weightKg) {
    setState(() {
      _heightController.text = heightCm.toStringAsFixed(0);
      _weightController.text = weightKg.toStringAsFixed(0);
    });
    _calculateBmi();
  }

  void _loadFromHistory(BmiRecord record) {
    setState(() {
      _heightController.text = record.heightCm.toStringAsFixed(0);
      _weightController.text = record.weightKg.toStringAsFixed(1);
      _calculatedBmi = record.bmi;
      _calculatedCategory = record.category;
      _lastHeight = record.heightCm;
      _lastWeight = record.weightKg;
      if (record.gender != null) _selectedGender = record.gender!;
      if (record.age != null) _ageController.text = record.age.toString();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded record from ${record.timestamp.toString().substring(0, 16)}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteRecord(String id) async {
    final updated = await StorageService.deleteRecord(id);
    setState(() {
      _history = updated;
    });
  }

  Future<void> _clearAllHistory() async {
    await StorageService.clearHistory();
    setState(() {
      _history = [];
    });
  }

  void _adjustHeight(double delta) {
    final current = double.tryParse(_heightController.text) ?? 170.0;
    final updated = (current + delta).clamp(50.0, 250.0);
    setState(() {
      _heightController.text = updated.toStringAsFixed(0);
    });
  }

  void _adjustWeight(double delta) {
    final current = double.tryParse(_weightController.text) ?? 70.0;
    final updated = (current + delta).clamp(10.0, 300.0);
    setState(() {
      _weightController.text = updated.toStringAsFixed(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BMI & Health Calculator',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'College UI Flutter Lab • External Exam Project',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Examination & Viva Info',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ExamInfoDialog(),
              );
            },
          ),
          IconButton(
            tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 960;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 32.0 : 16.0,
              vertical: 24.0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Quick test preset chips for examination demonstration
                    QuickTestPresets(onSelectPreset: _loadPreset),
                    const SizedBox(height: 20),

                    // Main Two-Column or Single Column Layout
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Panel: Form & Inputs
                          Expanded(
                            flex: 5,
                            child: _buildInputPanel(isDark),
                          ),
                          const SizedBox(width: 24),
                          // Right Panel: Results, Visual Scale, Health Advice, History
                          Expanded(
                            flex: 6,
                            child: _buildResultPanel(isDark),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildInputPanel(isDark),
                          const SizedBox(height: 24),
                          _buildResultPanel(isDark),
                        ],
                      ),

                    const SizedBox(height: 36),

                    // Mandatory Health Disclaimer Card
                    _buildDisclaimerCard(isDark),

                    const SizedBox(height: 24),

                    // Footer with Examination credits
                    _buildFooter(isDark),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Left Side Input Form Panel
  Widget _buildInputPanel(bool isDark) {
    final double currentHeight = double.tryParse(_heightController.text) ?? 170.0;
    final double currentWeight = double.tryParse(_weightController.text) ?? 70.0;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: isDark ? Colors.blue[300] : Colors.blue[700],
                ),
                const SizedBox(width: 8),
                Text(
                  'BODY PARAMETERS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Gender Selection
            Text(
              'Gender (Contextual)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.blueGrey[200] : Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Male', 'Female', 'Other'].map((gender) {
                final bool isSelected = _selectedGender == gender;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          _selectedGender = gender;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0284C7).withValues(alpha: isDark ? 0.25 : 0.12)
                              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0284C7)
                                : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            gender,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF0284C7)
                                  : (isDark ? Colors.blueGrey[300] : Colors.blueGrey[700]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Height Field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Height (Centimeters)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.blueGrey[200] : Colors.blueGrey[800],
                  ),
                ),
                Text(
                  'Range: 50 – 260 cm',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: BmiCalculatorService.validateHeight,
              onChanged: (val) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'e.g. 170',
                prefixIcon: const Icon(Icons.height_rounded),
                suffixText: 'cm',
                suffixIcon: _heightController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _heightController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8),

            // Height Quick Adjust Buttons & Slider
            Slider(
              value: currentHeight.clamp(50.0, 250.0),
              min: 50.0,
              max: 250.0,
              divisions: 200,
              label: '${currentHeight.toStringAsFixed(0)} cm',
              onChanged: (newVal) {
                setState(() {
                  _heightController.text = newVal.toStringAsFixed(0);
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildQuickAdjustButton('-5', () => _adjustHeight(-5), isDark),
                const SizedBox(width: 6),
                _buildQuickAdjustButton('-1', () => _adjustHeight(-1), isDark),
                const SizedBox(width: 6),
                _buildQuickAdjustButton('+1', () => _adjustHeight(1), isDark),
                const SizedBox(width: 6),
                _buildQuickAdjustButton('+5', () => _adjustHeight(5), isDark),
              ],
            ),

            const SizedBox(height: 20),

            // Weight Field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weight (Kilograms)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.blueGrey[200] : Colors.blueGrey[800],
                  ),
                ),
                Text(
                  'Range: 10 – 400 kg',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: BmiCalculatorService.validateWeight,
              onChanged: (val) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'e.g. 70.0',
                prefixIcon: const Icon(Icons.fitness_center_rounded),
                suffixText: 'kg',
                suffixIcon: _weightController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _weightController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8),

            // Weight Quick Adjust Buttons & Slider
            Slider(
              value: currentWeight.clamp(10.0, 200.0),
              min: 10.0,
              max: 200.0,
              divisions: 190,
              label: '${currentWeight.toStringAsFixed(1)} kg',
              onChanged: (newVal) {
                setState(() {
                  _weightController.text = newVal.toStringAsFixed(1);
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildQuickAdjustButton('-5', () => _adjustWeight(-5), isDark),
                const SizedBox(width: 6),
                _buildQuickAdjustButton('-1', () => _adjustWeight(-1), isDark),
                const SizedBox(width: 6),
                _buildQuickAdjustButton('+1', () => _adjustWeight(1), isDark),
                const SizedBox(width: 6),
                _buildQuickAdjustButton('+5', () => _adjustWeight(5), isDark),
              ],
            ),

            const SizedBox(height: 20),

            // Age Input (Optional Context)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Age (Adults 18+)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.blueGrey[200] : Colors.blueGrey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'e.g. 22',
                          prefixIcon: Icon(Icons.calendar_today_rounded),
                          suffixText: 'yrs',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Action Buttons: Calculate BMI & Reset
            Row(
              children: [
                // Reset Button
                OutlinedButton.icon(
                  onPressed: _resetAll,
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Calculate BMI Button
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _calculateBmi,
                    icon: const Icon(Icons.calculate_rounded),
                    label: const Text(
                      'Calculate BMI',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAdjustButton(String label, VoidCallback onPressed, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.blueGrey[200] : Colors.blueGrey[800],
          ),
        ),
      ),
    );
  }

  /// Right Side Results & History Panel
  Widget _buildResultPanel(bool isDark) {
    if (_calculatedBmi == null || _calculatedCategory == null) {
      return Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 64,
                color: isDark ? Colors.blueGrey[600] : Colors.blueGrey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Ready to Calculate',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.blueGrey[900],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter your height and weight on the left and tap "Calculate BMI".',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final double bmi = _calculatedBmi!;
    final BmiCategory category = _calculatedCategory!;
    final double height = _lastHeight ?? 170.0;
    final double weight = _lastWeight ?? 70.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary Result Card
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: category.borderColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: category.color.withValues(alpha: isDark ? 0.15 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  Text(
                    'CALCULATED RESULT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[700],
                    ),
                  ),
                  CategoryBadge(category: category, large: true),
                ],
              ),
              const SizedBox(height: 20),

              // Large BMI Score Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    bmi.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      color: category.color,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'kg/m²',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'WHO Classification: ${category.label}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.blueGrey[900],
                ),
              ),

              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 20),

              // Segmented visual gauge indicator
              BmiGauge(bmi: bmi, category: category),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Healthy Weight Range & Advice Card
        HealthAdviceCard(
          heightCm: height,
          weightKg: weight,
          category: category,
        ),

        const SizedBox(height: 20),

        // Local Storage Calculation History
        if (!_isLoadingHistory)
          HistoryView(
            records: _history,
            onSelectRecord: _loadFromHistory,
            onDeleteRecord: _deleteRecord,
            onClearHistory: _clearAllHistory,
          ),
      ],
    );
  }

  /// Mandatory Health Disclaimer Card satisfying Section 3-I
  Widget _buildDisclaimerCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withValues(alpha: 0.6)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: isDark ? Colors.amber[300] : Colors.amber[800],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HEALTH DISCLAIMER & CLINICAL NOTE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'BMI is a screening tool and does not directly measure body fat or diagnose medical conditions. BMI interpretation may differ for children, teenagers, pregnant individuals, and some athletes. Consult a qualified healthcare professional for medical advice.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Note: This calculator uses standard World Health Organization (WHO) adult BMI categories (ages 18+).',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.blueGrey[400] : Colors.blueGrey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isDark) {
    return Center(
      child: Text(
        'UI Flutter Lab External Examination Project • BMI & Health Calculator • Flutter Web 3.47',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.5,
          color: isDark ? Colors.blueGrey[500] : Colors.blueGrey[500],
        ),
      ),
    );
  }
}
