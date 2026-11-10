# PROJECT DOCUMENTATION REPORT

## **VitalScale**
### *Smart Anthropometric & Health Companion for Adults*

**Submitted in partial fulfillment of the requirements for:**  
**UI Design – Flutter (CS506PC) External Laboratory Examination**

---

### Student & Examination Particulars

| Particulars | Details |
| :--- | :--- |
| **Student Name** | Narayana Kadali |
| **Roll Number / Hall Ticket Number** | 24XV1M05XX *(Insert your Roll Number)* |
| **Programme & Branch** | B. Tech - Computer Science & Engineering (CSE) |
| **Institution** | Department of Computer Science & Engineering |
| **Academic Year** | 2026 - 2027 |
| **Semester** | III – I / IV – I |
| **Course Code & Title** | CS506PC: UI Design – Flutter Laboratory |
| **Repository** | [https://github.com/Narayanakadali/bmi-calculator-lab](https://github.com/Narayanakadali/bmi-calculator-lab) |
| **Live Application** | [https://narayanakadali.github.io/bmi-calculator-lab/](https://narayanakadali.github.io/bmi-calculator-lab/) |

---

### Project Overview

| Project Details | Specifications |
| :--- | :--- |
| **Project Title** | VitalScale (BMI & Health Calculator) |
| **Project Type** | Web Application |
| **Platform** | Flutter Web |
| **Programming Language** | Dart (Version 3.13.7) |
| **UI Framework** | Material 3 (Material Design M3) |
| **Data Storage** | SharedPreferences (HTML5 Local Browser Storage) |
| **Deployment** | GitHub Actions CI/CD and GitHub Pages |
| **Live Application** | [https://narayanakadali.github.io/bmi-calculator-lab/](https://narayanakadali.github.io/bmi-calculator-lab/) |
| **Source Code** | [https://github.com/Narayanakadali/bmi-calculator-lab](https://github.com/Narayanakadali/bmi-calculator-lab) |

---

## Table of Contents
1. **App Name and Introduction**
2. **Purpose and Objectives**
3. **Tools and Technologies**
4. **Features and Functionality**
5. **Important Code Snippets**
6. **Deployment Details**
7. **Screenshots / UI Output**

---

## 1. App Name and Introduction

- **App Name:** VitalScale
- **Tagline:** *Smart Anthropometric & Health Companion for Adults*

**VitalScale** is a modern, responsive, client-side Flutter Web application engineered for the UI Design – Flutter Laboratory External Examination. It empowers users to monitor and assess their physical health parameters through clinically validated anthropometric algorithms defined by the World Health Organization (WHO).

The application provides:
- Dual-unit body measurement inputs supporting both Metric (Centimeters, Kilograms) and Imperial (Feet & Inches, Pounds).
- Instant Body Mass Index (BMI) computation rounded strictly to one decimal place.
- Dynamic color-coded WHO category classification (Underweight, Normal Weight, Overweight, Obesity).
- Precise mathematical healthy weight range calculations ($18.5 \times H^2$ to $24.9 \times H^2$).
- A custom-painted, animated visual gauge indicating the exact BMI needle position on a continuous scale.
- Category-tailored dietary and physical activity recommendations.
- Local calculation history tracking with persistent storage via `SharedPreferences`.
- One-tap viva examination test presets.
- Theme switching between modern Material 3 Light Mode and Dark Mode.

VitalScale is developed in Dart using Flutter 3.x and is deployed as a live cloud web application through automated GitHub Actions workflows published to GitHub Pages.

---

## 2. Purpose and Objectives

### 2.1 Purpose
The purpose of VitalScale is to deliver a reliable, accessible, and user-friendly biometric screening dashboard that assists individuals in evaluating their body mass classification against clinical standards, while demonstrating professional proficiency in Flutter Web design, defensive input validation, asynchronous browser storage, and automated cloud CI/CD pipelines.

### 2.2 Objectives
1. **Clinical Accuracy:** Compute Body Mass Index according to standard WHO formulas: $\text{BMI} = \text{Weight (kg)} / (\text{Height in meters})^2$.
2. **Dual-Unit Flexibility:** Enable seamless, live two-way switching between Metric units (cm, kg) and Imperial units (ft/in, lbs) with instant conversion feedback.
3. **Defensive Validation:** Prevent crashes and invalid computations by validating empty inputs, zero values, negative entries, non-numeric characters, and unrealistic physiological values ($50-260\text{ cm}$, $10-400\text{ kg}$).
4. **Dynamic Visual Feedback:** Provide a mathematically mapped, animated segmented scale with an indicator needle showing the user's BMI position.
5. **Healthy Weight Boundary Analysis:** Compute the ideal healthy weight interval for the entered height and state the exact delta required to reach a normal weight.
6. **Client-Side Data Persistence:** Store calculation history locally using browser `LocalStorage` via `SharedPreferences`, avoiding external database requirements.
7. **Examination Demonstration Readiness:** Provide one-tap test presets for Underweight, Normal, Overweight, and Obesity cases for fast viva evaluation.
8. **Responsive Material 3 Design:** Ensure seamless adaptability across desktop widescreen monitors, tablets, and mobile smartphones in both light and dark themes.
9. **Cloud Web Deployment:** Automate building, testing, and continuous hosting via GitHub Pages.

---

## 3. Tools and Technologies

| Category | Tools Used |
| :--- | :--- |
| **Frontend Framework** | Flutter Web 3.47.9 (Stable Channel) |
| **Language** | Dart 3.13.7 |
| **UI Design System** | Material Design 3 (M3) Specification |
| **Development Tools** | Antigravity IDE, Visual Studio Code, Chrome DevTools |
| **Data Storage** | `shared_preferences: ^2.3.2` (HTML5 LocalStorage) |
| **Utility Packages** | `intl: ^0.19.0` (Locale-aware date & time formatting) |
| **Testing Harness** | `flutter_test` (Unit and Widget Integration Testing) |
| **Version Control** | Git, GitHub |
| **CI/CD & Deployment** | GitHub Actions, GitHub Pages, Vercel |

*Table 1: Tools and technologies used in VitalScale*

> **Note on Data Storage:** `SharedPreferences` is used to persist historical calculation records directly inside the client's browser `LocalStorage`. Consequently, user records persist across browser reloads without requiring any backend server or database infrastructure.

---

## 4. Features and Functionality

### 4.1 Dual-Unit Body Parameter Inputs
VitalScale accommodates user preferences by supporting both Metric and Imperial units:
- **Height Selection:**
  - *Centimeters (`cm`):* Text input field, interactive slider ($50 - 250\text{ cm}$), and quick $\pm 1\text{ cm}$ / $\pm 5\text{ cm}$ buttons. Live subtitle shows: `≈ 5 ft 7 in (66.9 inches)`.
  - *Feet & Inches (`ft & in`):* Dedicated dual fields for Feet (ft) and Inches (in) with live conversion to centimeters and $\pm 1\text{ in}$ / $\pm 1\text{ ft}$ buttons.
- **Weight Selection:**
  - *Kilograms (`kg`):* Text input field, interactive slider ($10 - 200\text{ kg}$), and quick $\pm 1\text{ kg}$ / $\pm 5\text{ kg}$ buttons. Live subtitle shows: `≈ 154.3 lbs`.
  - *Pounds (`lbs`):* Text input field, interactive slider ($22 - 440\text{ lbs}$), and quick $\pm 2\text{ lbs}$ / $\pm 10\text{ lbs}$ buttons. Live subtitle shows: `≈ 70.0 kg`.
- **Gender & Age Context:** Optional selection chips for Male, Female, and Other, plus an age field for clinical screening context.

### 4.2 Precision Body Mass Index (BMI) Engine
Calculates Body Mass Index using the standard algebraic equation:
$$\text{BMI} = \frac{\text{Weight in Kilograms}}{(\text{Height in Meters})^2}$$
The output is rounded strictly to one decimal place (e.g., $170\text{ cm}, 70.0\text{ kg} \rightarrow \mathbf{24.2\text{ kg/m}^2}$).

### 4.3 WHO Classification & Dynamic Badges
Calculated results are mapped into standard World Health Organization adult categories:
- **Underweight:** $\text{BMI} < 18.5$ — Sky Blue badge (`#0288D1`)
- **Normal Weight:** $\text{BMI } 18.5 - 24.9$ — Emerald Green badge (`#2E7D32`)
- **Overweight:** $\text{BMI } 25.0 - 29.9$ — Amber/Orange badge (`#F57C00`)
- **Obesity:** $\text{BMI } \ge 30.0$ — Crimson Red badge (`#D32F2F`)

### 4.4 Estimated Healthy Weight Range & Target Delta
Based on the entered height, the application computes:
- $\text{Minimum Healthy Weight} = 18.5 \times (H\text{ in meters})^2$
- $\text{Maximum Healthy Weight} = 24.9 \times (H\text{ in meters})^2$
- **Weight Difference Status:** Informs whether the user is within the healthy zone, or how many kilograms they are above/below the normal threshold.

### 4.5 Mathematically Calibrated Segmented Visual Gauge
A custom visual progress gauge displays the four WHO categories across a continuous horizontal scale ($15.0 - 40.0$). An animated indicator needle with an elevated numeric bubble smoothly glides to the exact computed BMI position using an easing curve.

### 4.6 Tailored Dietary & Physical Activity Guidance
Dynamically renders clinical lifestyle recommendations:
- **Dietary Advice:** Nutritional advice customized to the active category (e.g., lean protein and whole grains for Normal; caloric density for Underweight; portion moderation for Overweight/Obese).
- **Physical Activity:** Recommended exercise routines (e.g., 150 minutes of weekly aerobic exercise; resistance training; low-impact routines).

### 4.7 Local Calculation History & Persistent Storage
Recent BMI calculations are stored in browser `LocalStorage` via `SharedPreferences`. The history view displays:
- Calculated BMI score and WHO category badge.
- Recorded height and weight in both metric and imperial formats.
- Timestamp formatted using `intl` (e.g., `Nov 10, 2026 • 08:00 AM`).
- Reload past record on tap, single record deletion, and clear-all confirmation dialog.

### 4.8 One-Tap Viva Examination Demonstration Presets
Four instant preset buttons are available at the top of the interface:
- **Underweight Demo:** $175\text{ cm}, 50\text{ kg} \rightarrow \text{BMI } 16.3$
- **Normal Demo:** $170\text{ cm}, 65\text{ kg} \rightarrow \text{BMI } 22.5$
- **Overweight Demo:** $170\text{ cm}, 78\text{ kg} \rightarrow \text{BMI } 27.0$
- **Obesity Demo:** $160\text{ cm}, 85\text{ kg} \rightarrow \text{BMI } 33.2$

### 4.9 Theme Support
Supports instant switching between Material 3 Light Mode and Dark Mode with smooth color transitions.

### 4.10 Complete Reset Functionality & Health Disclaimer
- **Reset Button:** Clears all input controllers, sliders, calculation results, and error messages, returning the dashboard to its initial ready state.
- **Health Disclaimer:** Features the mandatory WHO screening notice emphasizing that BMI is an anthropometric screening tool and does not replace medical consultation.

### 4.11 Responsive Design
Adapts dynamically across screen widths:
- **Desktop / Tablet ($\ge 960\text{px}$):** Two-column layout (Left: Input Panel & Controls; Right: Results, Gauge, Advice, History).
- **Mobile Viewport ($< 960\text{px}$):** Stacked vertical scrollable layout with touch-friendly controls.

---

## 5. Important Code Snippets

### 5.1 Application Entry Point
The application initializes Flutter bindings and launches the `BmiHealthApp` widget.

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BmiHealthApp());
}
```

### 5.2 BMI Calculation & Healthy Range Algorithms
Pure Dart algorithms in `BmiCalculatorService` compute BMI and healthy weight boundaries rounded to one decimal place.

```dart
static double calculateBmi({
  required double weightKg,
  required double heightCm,
}) {
  if (heightCm <= 0 || weightKg <= 0) {
    throw ArgumentError('Height and weight must be strictly positive.');
  }
  final double heightMeters = heightCm / 100.0;
  final double rawBmi = weightKg / (heightMeters * heightMeters);
  return roundToOneDecimal(rawBmi);
}

static ({double minWeightKg, double maxWeightKg}) calculateHealthyWeightRange(
  double heightCm,
) {
  final double heightM = heightCm / 100.0;
  final double heightSquared = heightM * heightM;
  return (
    minWeightKg: roundToOneDecimal(18.5 * heightSquared),
    maxWeightKg: roundToOneDecimal(24.9 * heightSquared),
  );
}
```

### 5.3 Unit Conversion Engine (Metric $\leftrightarrow$ Imperial)
Handles instant two-way conversions between centimeters, feet/inches, kilograms, and pounds.

```dart
static double feetAndInchesToCm(int feet, double inches) {
  return roundToOneDecimal((feet * 30.48) + (inches * 2.54));
}

static ({int feet, double inches}) cmToFeetAndInches(double cm) {
  final double totalInches = cm / 2.54;
  final int feet = (totalInches / 12).floor();
  final double inches = roundToOneDecimal(totalInches % 12);
  return (feet: feet, inches: inches);
}

static double lbsToKg(double lbs) => roundToOneDecimal(lbs * 0.45359237);
static double kgToLbs(double kg) => roundToOneDecimal(kg / 0.45359237);
```

### 5.4 Defensive Input Validation
Prevents runtime exceptions and alerts the user to physiological boundary violations.

```dart
static String? validateHeight(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your height in centimeters.';
  }
  final double? parsed = double.tryParse(value.trim());
  if (parsed == null) return 'Invalid entry: height must be a number.';
  if (parsed <= 0) return 'Height must be greater than zero.';
  if (parsed < minRealisticHeightCm || parsed > maxRealisticHeightCm) {
    return 'Height must be between $minRealisticHeightCm and $maxRealisticHeightCm cm.';
  }
  return null;
}
```

### 5.5 Local Storage Persistence (`StorageService`)
Saves and retrieves calculation history from browser `LocalStorage` via JSON serialization.

```dart
static Future<List<BmiRecord>> saveRecord(BmiRecord record) async {
  final List<BmiRecord> current = await loadHistory();
  current.insert(0, record);
  if (current.length > _maxHistoryItems) {
    current.removeRange(_maxHistoryItems, current.length);
  }
  final prefs = await SharedPreferences.getInstance();
  final String encoded = jsonEncode(current.map((r) => r.toJson()).toList());
  await prefs.setString(_historyKey, encoded);
  return current;
}
```

### 5.6 Animated Visual Gauge Positioning
Maps the BMI score to a normalized percentage ($0.0 - 1.0$) across the segmented gauge.

```dart
static double calculateGaugePosition(double bmi) {
  final double clamped = bmi.clamp(15.0, 40.0);
  if (clamped <= 18.5) {
    return math.max(0.02, (clamped - 15.0) / (18.5 - 15.0) * 0.20);
  } else if (clamped <= 25.0) {
    return 0.20 + ((clamped - 18.5) / (25.0 - 18.5) * 0.35);
  } else if (clamped <= 30.0) {
    return 0.55 + ((clamped - 25.0) / (30.0 - 25.0) * 0.25);
  } else {
    return math.min(0.98, 0.80 + ((clamped - 30.0) / (40.0 - 30.0) * 0.20));
  }
}
```

### 5.7 Theme Management
Supports dynamic switching between Material 3 Light Mode and Dark Mode.

```dart
themeMode: _themeMode,

void _toggleTheme() {
  setState(() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  });
}
```

### 5.8 Project Structure
```
VitalScale/
├── lib/
│   ├── main.dart                      # App entry point, M3 theming, responsive layout
│   ├── models/
│   │   ├── bmi_category.dart          # WHO Category enum, colors, dietary & activity guidance
│   │   └── bmi_record.dart            # History record data model with JSON serialization
│   ├── services/
│   │   ├── bmi_calculator_service.dart # Pure calculation math, unit converters, validators
│   │   └── storage_service.dart       # SharedPreferences wrapper for web LocalStorage
│   └── widgets/
│       ├── bmi_gauge.dart             # Custom animated segmented scale with cursor
│       ├── category_badge.dart        # M3 pill badges showing category & limits
│       ├── health_advice_card.dart    # Healthy weight range & lifestyle advice widget
│       ├── history_view.dart          # LocalStorage history listing with clear/delete
│       ├── quick_test_presets.dart    # 1-tap viva demo presets
│       └── exam_info_dialog.dart      # In-app dialog with theoretical formulas & exam details
├── test/
│   └── widget_test.dart               # Automated unit tests and UI integration tests
├── web/
│   ├── index.html                     # HTML5 entry with loader spinner & metadata
│   └── manifest.json                  # Web application manifest
├── .github/
│   └── workflows/
│       └── deploy.yml                 # Automated GitHub Actions deployment pipeline
├── vercel.json                        # Vercel cloud deployment configuration
├── DOCUMENTATION_REPORT.md            # Complete printable laboratory report
├── ANSWER_BOOKLET_SUMMARY.md          # Physical booklet summary & viva prep
├── pubspec.yaml                       # Dependencies and asset declarations
└── README.md                          # Repository overview & setup instructions
```

---

## 6. Deployment Details

VitalScale is deployed as a high-performance Flutter Web application hosted globally on GitHub Pages using an automated GitHub Actions CI/CD pipeline.

### 6.1 Deployment Process
1. **Local Development:** Flutter Web application constructed, modularized, and tested locally.
2. **Version Control:** Git repository initialized and pushed to GitHub main branch.
3. **CI/CD Pipeline:** GitHub Actions workflow triggered on every push.
4. **Environment Setup:** Virtual machine configures Flutter SDK channel `stable`.
5. **Dependency Resolution:** Runs `flutter pub get` to fetch dependencies.
6. **Automated Testing:** Runs `flutter test` — all 7 unit and widget tests must pass.
7. **Release Compilation:** Builds optimized production web bundle:  
   `flutter build web --release --base-href "/bmi-calculator-lab/"`
8. **Artifact Upload:** Compresses `build/web` and publishes it to GitHub Pages.
9. **Global Availability:** Application is immediately reachable via secure HTTPS URL.

### 6.2 Deployment Workflow Diagram

```
Local Flutter Project
        ↓
    Git Commit
        ↓
GitHub Remote Repository (main branch)
        ↓
GitHub Actions CI/CD Pipeline
        ↓
flutter pub get
        ↓
flutter test (7 Passed, 0 Failed)
        ↓
flutter build web --release
        ↓
build/web Artifact Upload
        ↓
GitHub Pages CDN
        ↓
Live VitalScale Web Application
```

### 6.3 Deployment Links
- **Live Application:** [https://narayanakadali.github.io/bmi-calculator-lab/](https://narayanakadali.github.io/bmi-calculator-lab/)
- **Source Code Repository:** [https://github.com/Narayanakadali/bmi-calculator-lab](https://github.com/Narayanakadali/bmi-calculator-lab)

---

## 7. Screenshots / UI Output

### Screenshot 1 — Main Dashboard & Dual-Unit Parameters
```
+-------------------------------------------------------------------------------------------------+
| [❤] VitalScale — BMI & Health Calculator   College UI Flutter Lab Exam     [ⓘ Info]  [☼ Theme] |
+-------------------------------------------------------------------------------------------------+
| QUICK EXAM TEST PRESETS: [Underweight (175,50)] [Normal (170,65)] [Overweight] [Obesity]       |
+----------------------------------------------------+--------------------------------------------+
| BODY PARAMETERS                                    | CALCULATED RESULT          [Normal Weight] |
|                                                    |                                            |
| Gender: [ Male ] ( Female ) ( Other )              |                 24.2 kg/m²                 |
|                                                    | WHO Classification: Normal Weight          |
| Height (Centimeters)             [ cm | ft & in ]  | 170 cm (5' 7.0")  •  70.0 kg (154.3 lbs)   |
| [ 170                        ] [cm] [x]            |                                            |
| ≈ 5 ft 7 in (66.9 inches)                          | BMI VISUAL SCALE:                          |
| [--------●-------------------------] 170 cm        | [Blue  | Green=====| Orange | Red       ]  |
| [-5 cm] [-1 cm] [+1 cm] [+5 cm]                    |   15.0     18.5      25.0     30.0   40.0  |
|                                                    |                                            |
| Weight (Kilograms)                 [ kg | lbs ]    | HEALTH & WEIGHT ANALYSIS                   |
| [ 70.0                       ] [kg] [x]            | Estimated Healthy Range:                   |
| ≈ 154.3 lbs                                        |          53.5 kg – 72.0 kg                 |
| [-----------●----------------------] 70.0 kg       | Status: Currently in ideal healthy range   |
| [-5 kg] [-1 kg] [+1 kg] [+5 kg]                    |                                            |
|                                                    | DIETARY & LIFESTYLE ADVICE:                |
| Age: [ 22                    ] [yrs]               | • Whole grains & lean protein daily        |
|                                                    | • 150 mins weekly aerobic exercise         |
| [ Reset ]                       [ Calculate BMI ]  |                                            |
|                                                    | CALCULATION HISTORY:          [Clear All]  |
|                                                    | • 170 cm, 70.0 kg -> 24.2 (Normal Weight)  |
|                                                    |   Nov 10, 2026 • 08:00 AM                  |
+----------------------------------------------------+--------------------------------------------+
| HEALTH DISCLAIMER:                                                                              |
| BMI is a screening tool and does not directly measure body fat or diagnose medical conditions.  |
| Consult a qualified healthcare professional for medical advice.                                 |
+-------------------------------------------------------------------------------------------------+
```
*Figure 1: VitalScale Main Dashboard (Dual Column Desktop View)*

---

### Screenshot 2 — Imperial Units Active (Feet/Inches & Pounds)
```
+----------------------------------------------------+
| Height (Feet & Inches)            [ cm | ft & in ] |
| [ 5         ] ft       [ 7.0       ] in            |
| ≈ 170 cm (67.0 total inches)                       |
| [-1 in] [+1 in] [-1 ft] [+1 ft]                    |
|                                                    |
| Weight (Pounds)                       [ kg | lbs ] |
| [ 154.3                             ] [lbs]        |
| ≈ 70.0 kg                                          |
| [----------●-----------------------] 154.3 lbs     |
| [-10 lbs] [-2 lbs] [+2 lbs] [+10 lbs]              |
+----------------------------------------------------+
```
*Figure 2: Imperial Units Input Mode with Real-Time Conversion Display*

---

### Screenshot 3 — Underweight Evaluation Output
```
+----------------------------------------------------+
| CALCULATED RESULT                    [Underweight] |
|                                                    |
|                 16.3 kg/m²                         |
| WHO Classification: Underweight                    |
| 175 cm (5' 8.9")  •  50.0 kg (110.2 lbs)           |
|                                                    |
| BMI SCALE:                                         |
| [Blue==| Green     | Orange     | Red            ] |
|   ▲ (Needle positioned at 16.3)                    |
|                                                    |
| HEALTH ANALYSIS:                                   |
| Estimated Healthy Range: 56.7 kg – 76.3 kg         |
| Status: 6.7 kg below minimum healthy weight        |
+----------------------------------------------------+
```
*Figure 3: Underweight Test Output with Category Indicator and Scale Pointer*

---

### Screenshot 4 — Overweight Evaluation Output
```
+----------------------------------------------------+
| CALCULATED RESULT                     [Overweight] |
|                                                    |
|                 27.0 kg/m²                         |
| WHO Classification: Overweight                     |
| 170 cm (5' 7.0")  •  78.0 kg (172.0 lbs)           |
|                                                    |
| BMI SCALE:                                         |
| [Blue  | Green     | Orange==   | Red            ] |
|                        ▲ (Needle positioned at 27.0)|
|                                                    |
| HEALTH ANALYSIS:                                   |
| Estimated Healthy Range: 53.5 kg – 72.0 kg         |
| Status: 6.0 kg above maximum healthy weight        |
+----------------------------------------------------+
```
*Figure 4: Overweight Test Output with Caloric Reduction Advice*

---

### Screenshot 5 — Obesity Evaluation Output
```
+----------------------------------------------------+
| CALCULATED RESULT                        [Obesity] |
|                                                    |
|                 33.2 kg/m²                         |
| WHO Classification: Obesity                        |
| 160 cm (5' 3.0")  •  85.0 kg (187.4 lbs)           |
|                                                    |
| BMI SCALE:                                         |
| [Blue  | Green     | Orange     | Red====        ] |
|                                     ▲ (At 33.2)    |
|                                                    |
| HEALTH ANALYSIS:                                   |
| Estimated Healthy Range: 47.4 kg – 63.7 kg         |
| Status: 21.3 kg above maximum healthy weight       |
+----------------------------------------------------+
```
*Figure 5: Obesity Test Output with Clinical Consultation Recommendation*

---

### Screenshot 6 — Calculation History Management
```
+-----------------------------------------------------------------+
| CALCULATION HISTORY                              [Clear All (3)]|
|-----------------------------------------------------------------|
| (24.2) 170 cm • 70.0 kg [Normal Weight]                         |
|        Nov 10, 2026 • 08:00 AM                              [x] |
|-----------------------------------------------------------------|
| (27.0) 170 cm • 78.0 kg [Overweight]                            |
|        Nov 10, 2026 • 07:55 AM                              [x] |
|-----------------------------------------------------------------|
| (16.3) 175 cm • 50.0 kg [Underweight]                           |
|        Nov 10, 2026 • 07:50 AM                              [x] |
+-----------------------------------------------------------------+
```
*Figure 6: Browser LocalStorage Calculation History with Reload and Deletion*

---

### Screenshot 7 — Settings & Theme Toggle
```
+-----------------------------------------------------------------+
| [←] Settings                                                    |
|                                                                 |
| Appearance                                                      |
| [☼] Dark Mode                                          [ (●) ]  |
|     Modern Material 3 dark theme is enabled                     |
|                                                                 |
| Data Management                                                 |
| [🗑] Clear Local Data                                           |
|     Remove all saved BMI records from browser storage       [>] |
|                                                                 |
| About                                                           |
| [ⓘ] VitalScale — Version 1.0.0+1                                |
|     UI Design – Flutter Laboratory External Examination         |
+-----------------------------------------------------------------+
```
*Figure 7: Application Settings and Theme Configuration Interface*

---

### Screenshot 8 — Mobile Responsive UI
```
+-------------------------------+
| [❤] VitalScale        [☼] [ⓘ] |
+-------------------------------+
| QUICK PRESETS:                |
| [Normal] [Under] [Over] [Obese]
+-------------------------------+
| BODY PARAMETERS               |
|                               |
| Height: [ 170     ] [cm]      |
| [------●-----------------]    |
|                               |
| Weight: [ 70.0    ] [kg]      |
| [---------●--------------]    |
|                               |
| [ Reset ]   [ Calculate BMI ] |
+-------------------------------+
| CALCULATED RESULT             |
|                               |
|          24.2 kg/m²           |
|      Normal Weight (WHO)      |
|                               |
| [Blue | Green== | Org | Red]  |
|                               |
| Healthy: 53.5 kg – 72.0 kg    |
+-------------------------------+
| [📜] CALCULATION HISTORY      |
| • 170 cm, 70 kg → 24.2 (Nov 10)
+-------------------------------+
| HEALTH DISCLAIMER             |
| Consult a healthcare expert   |
+-------------------------------+
```
*Figure 8: Responsive Mobile Smartphone Layout*
