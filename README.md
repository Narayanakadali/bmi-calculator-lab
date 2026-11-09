# 🩺 BMI & Health Calculator — Flutter Web Application

[![Flutter Version](https://img.shields.io/badge/Flutter-3.47.9-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.13.7-0175C2?logo=dart)](https://dart.dev)
[![UI Design](https://img.shields.io/badge/Design-Material%203-795548)](https://m3.material.io)
[![License](https://img.shields.io/badge/License-Academic%20Use-success)](#)
[![Tests](https://img.shields.io/badge/Tests-6%20Passed%20(100%25)-brightgreen)](#automated-testing)

A complete, examination-ready **BMI & Health Calculator** web application built with Flutter Material 3 for the College UI Flutter Laboratory External Examination.

---

## 🌟 Key Application Features

- **Accurate Mathematical Computation:**
  - Implements standard WHO Body Mass Index formula: $\text{BMI} = \text{Weight (kg)} / (\text{Height in meters})^2$.
  - Displays calculated BMI rounded to one decimal place (e.g., $170\text{ cm}, 70\text{ kg} \rightarrow 24.2\text{ kg/m}^2$).
- **WHO Adult Classification:**
  - **Underweight:** $\text{BMI} < 18.5$ (Sky Blue)
  - **Normal Weight:** $\text{BMI } 18.5 - 24.9$ (Emerald Green)
  - **Overweight:** $\text{BMI } 25.0 - 29.9$ (Amber / Orange)
  - **Obesity:** $\text{BMI } \ge 30.0$ (Crimson Red)
- **Estimated Healthy Weight Range:**
  - Calculates minimum healthy weight ($18.5 \times H^2$) and maximum healthy weight ($24.9 \times H^2$).
  - Shows exact delta (kilograms above/below healthy boundaries).
- **Segmented Visual Scale:**
  - Mathematically calibrated horizontal gauge with animated needle cursor indicating the user's BMI position.
- **Client-Side History Tracking:**
  - Saves calculation history to browser `LocalStorage` via `shared_preferences`.
  - Displays formatted timestamps, values, and category chips.
  - Supports individual record deletion and full history wipe.
- **Defensive Input Validation:**
  - Sanitizes empty fields, non-numeric characters, zero, negative values, and out-of-bounds physiological inputs ($50 - 260\text{ cm}$, $10 - 400\text{ kg}$).
- **Reset Functionality:**
  - One-tap reset restoring inputs, sliders, and calculations to initial state.
- **One-Tap Viva Demonstration Presets:**
  - Instant preset chips for Underweight, Normal, Overweight, and Obesity cases for fast external examiner demonstration.
- **Theme Support:**
  - Toggle between modern Material 3 Dark Mode and Light Mode.
- **Mandatory Clinical Disclaimer:**
  - Full WHO adult screening disclaimer embedded in footer.

---

## 📁 Project Architecture

```
lib/
├── main.dart                      # App entry point, M3 themes, responsive layout
├── models/
│   ├── bmi_category.dart          # Category enum, colors, dietary & activity guidance
│   └── bmi_record.dart            # History record data model with JSON serialization
├── services/
│   ├── bmi_calculator_service.dart # Pure calculation math, healthy range, validators
│   └── storage_service.dart       # SharedPreferences wrapper for web LocalStorage
└── widgets/
    ├── bmi_gauge.dart             # Custom animated segmented gauge with pointer
    ├── category_badge.dart        # M3 pill badge showing category and ranges
    ├── health_advice_card.dart    # Healthy weight range & lifestyle advice widget
    ├── history_view.dart          # LocalStorage history listing with clear/delete
    ├── quick_test_presets.dart    # 1-tap viva demo presets
    └── exam_info_dialog.dart      # In-app dialog with theory formulas & exam details
```

---

## 🚀 Running the Project Locally

1. Clone or open the project folder in terminal:
   ```bash
   cd "d:\Users\BMI caluclator -LAB"
   ```
2. Retrieve packages:
   ```bash
   flutter pub get
   ```
3. Run automated tests:
   ```bash
   flutter test
   ```
4. Run in Chrome browser:
   ```bash
   flutter run -d chrome
   ```

---

## 🌐 Live Application URL & Deployment

- **Live URL:** [https://narayanakadali.github.io/bmi-calculator-lab/](https://narayanakadali.github.io/bmi-calculator-lab/)
- **Repository:** [https://github.com/Narayanakadali/bmi-calculator-lab](https://github.com/Narayanakadali/bmi-calculator-lab)

### Deploying to GitHub Pages (College Submission)

1. **Push to GitHub:**
   ```bash
   git push -u origin main
   ```
2. **Enable GitHub Pages:**
   - In your repository, go to **Settings** > **Pages**.
   - Under **Build and deployment** > **Source**, choose **GitHub Actions**.
3. GitHub Actions (`.github/workflows/deploy.yml`) will automatically build, test, and host the web application at:
   ```
   https://narayanakadali.github.io/bmi-calculator-lab/
   ```
4. Copy and paste the live URL into the college examination submission Google Sheet.

---

## 📄 Examination Documentation

- **Printable Lab Report:** [DOCUMENTATION_REPORT.md](file:///d:/Users/BMI%20caluclator%20-LAB/DOCUMENTATION_REPORT.md) (ready for Black & White printing)
- **Answer Booklet & Viva Prep:** [ANSWER_BOOKLET_SUMMARY.md](file:///d:/Users/BMI%20caluclator%20-LAB/ANSWER_BOOKLET_SUMMARY.md) (concise summaries and model viva answers)
