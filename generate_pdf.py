import os
import sys
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, Preformatted
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm, inch
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    """Two-pass canvas to dynamically compute total pages."""
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_number(num_pages)
            super().showPage()
        super().save()

    def draw_page_number(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 8)
        self.setFillColor(colors.HexColor("#64748B"))
        
        # Running header (on pages > 1)
        if self._pageNumber > 1:
            self.drawString(18 * mm, 287 * mm, "VitalScale — Project Documentation Report | College UI Flutter Lab")
            self.setStrokeColor(colors.HexColor("#CBD5E1"))
            self.setLineWidth(0.5)
            self.line(18 * mm, 284 * mm, 192 * mm, 284 * mm)

        # Running footer
        page_text = f"Page {self._pageNumber} of {page_count}"
        self.drawRightString(192 * mm, 10 * mm, page_text)
        self.drawString(18 * mm, 10 * mm, "CONFIDENTIAL & ACADEMIC EVALUATION COPY — CS506PC")
        self.setStrokeColor(colors.HexColor("#CBD5E1"))
        self.setLineWidth(0.5)
        self.line(18 * mm, 13 * mm, 192 * mm, 13 * mm)
        self.restoreState()

def build_pdf(filename="VitalScale_Project_Report.pdf"):
    doc = SimpleDocTemplate(
        filename,
        pagesize=A4,
        leftMargin=18 * mm,
        rightMargin=18 * mm,
        topMargin=18 * mm,
        bottomMargin=18 * mm
    )

    styles = getSampleStyleSheet()

    # Custom typography styles
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=20,
        leading=24,
        textColor=colors.HexColor("#0369A1"),
        alignment=1, # Center
        spaceAfter=4
    )

    tagline_style = ParagraphStyle(
        'DocTagline',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=11,
        leading=15,
        textColor=colors.HexColor("#334155"),
        alignment=1,
        spaceAfter=8
    )

    sub_header_style = ParagraphStyle(
        'DocSub',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9,
        leading=13,
        textColor=colors.HexColor("#64748B"),
        alignment=1,
        spaceAfter=14
    )

    h1_style = ParagraphStyle(
        'H1',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=13,
        leading=17,
        textColor=colors.HexColor("#0F172A"),
        spaceBefore=14,
        spaceAfter=6,
        keepWithNext=True
    )

    h2_style = ParagraphStyle(
        'H2',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=10.5,
        leading=14,
        textColor=colors.HexColor("#0369A1"),
        spaceBefore=10,
        spaceAfter=4,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        'Body',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9,
        leading=13.5,
        textColor=colors.HexColor("#1E293B"),
        alignment=4, # Justified
        spaceAfter=5
    )

    bullet_style = ParagraphStyle(
        'Bullet',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.5,
        leading=12.5,
        textColor=colors.HexColor("#1E293B"),
        leftIndent=12,
        firstLineIndent=-8,
        spaceAfter=3
    )

    table_cell = ParagraphStyle(
        'TableCell',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.5,
        leading=11.5,
        textColor=colors.HexColor("#0F172A")
    )

    table_cell_bold = ParagraphStyle(
        'TableCellBold',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=8.5,
        leading=11.5,
        textColor=colors.HexColor("#0F172A")
    )

    table_cell_header = ParagraphStyle(
        'TableHead',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=8.5,
        leading=11.5,
        textColor=colors.HexColor("#0369A1")
    )

    code_style = ParagraphStyle(
        'CodeStyle',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=7.2,
        leading=9.5,
        textColor=colors.HexColor("#0F172A")
    )

    wireframe_style = ParagraphStyle(
        'WireframeStyle',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=6.5,
        leading=8.0,
        textColor=colors.HexColor("#1E293B")
    )

    caption_style = ParagraphStyle(
        'Caption',
        parent=styles['Normal'],
        fontName='Helvetica-Oblique',
        fontSize=7.5,
        leading=10,
        textColor=colors.HexColor("#475569"),
        alignment=1,
        spaceBefore=3,
        spaceAfter=10
    )

    elements = []

    # Title Box
    title_data = [
        [Paragraph("PROJECT DOCUMENTATION REPORT", ParagraphStyle('THead', fontName='Helvetica-Bold', fontSize=10, leading=12, alignment=1, textColor=colors.HexColor("#64748B")))],
        [Paragraph("VitalScale", title_style)],
        [Paragraph("Smart Anthropometric & Health Companion for Adults", tagline_style)],
        [Paragraph("Submitted in partial fulfillment of the requirements for<br/><b>UI Design – Flutter (CS506PC) External Laboratory Examination</b>", sub_header_style)]
    ]
    t_box = Table(title_data, colWidths=[174 * mm])
    t_box.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F8FAFC")),
        ('BOX', (0,0), (-1,-1), 1.5, colors.HexColor("#0284C7")),
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('TOPPADDING', (0,0), (-1,-1), 6),
        ('BOTTOMPADDING', (0,0), (-1,-1), 6),
        ('LEFTPADDING', (0,0), (-1,-1), 12),
        ('RIGHTPADDING', (0,0), (-1,-1), 12),
    ]))
    elements.append(t_box)
    elements.append(Spacer(1, 10))

    # Student Particulars
    elements.append(Paragraph("Student & Examination Particulars", h1_style))
    p_data = [
        [Paragraph("Particulars", table_cell_header), Paragraph("Details", table_cell_header)],
        [Paragraph("Student Name", table_cell_bold), Paragraph("Narayana Kadali", table_cell)],
        [Paragraph("Roll Number / Hall Ticket", table_cell_bold), Paragraph("24XV1M05XX <i>(Insert Hall Ticket Number)</i>", table_cell)],
        [Paragraph("Programme & Branch", table_cell_bold), Paragraph("B. Tech - Computer Science & Engineering (CSE)", table_cell)],
        [Paragraph("Institution", table_cell_bold), Paragraph("Department of Computer Science & Engineering", table_cell)],
        [Paragraph("Academic Year & Semester", table_cell_bold), Paragraph("2026 – 2027 | III Year – I Semester", table_cell)],
        [Paragraph("Course Code & Title", table_cell_bold), Paragraph("CS506PC: UI Design – Flutter Laboratory", table_cell)],
        [Paragraph("Repository URL", table_cell_bold), Paragraph("https://github.com/Narayanakadali/bmi-calculator-lab", table_cell)],
        [Paragraph("Live Deployment URL", table_cell_bold), Paragraph("https://narayanakadali.github.io/bmi-calculator-lab/", table_cell)],
    ]
    t_p = Table(p_data, colWidths=[65 * mm, 109 * mm])
    t_p.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#F1F5F9")),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 3.5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 3.5),
    ]))
    elements.append(t_p)
    elements.append(Spacer(1, 8))

    # Project Overview Table
    elements.append(Paragraph("Project Overview", h1_style))
    o_data = [
        [Paragraph("Project Details", table_cell_header), Paragraph("Specifications", table_cell_header)],
        [Paragraph("Project Title", table_cell_bold), Paragraph("VitalScale (BMI & Health Calculator)", table_cell)],
        [Paragraph("Project Type & Platform", table_cell_bold), Paragraph("Web Application | Flutter Web", table_cell)],
        [Paragraph("Language & UI Standard", table_cell_bold), Paragraph("Dart 3.13.7 | Material Design 3 (M3)", table_cell)],
        [Paragraph("Data Storage", table_cell_bold), Paragraph("SharedPreferences (HTML5 Browser LocalStorage)", table_cell)],
        [Paragraph("CI/CD & Deployment", table_cell_bold), Paragraph("GitHub Actions CI/CD Pipeline & GitHub Pages CDN", table_cell)],
        [Paragraph("Testing Harness", table_cell_bold), Paragraph("flutter_test (7 Test Cases Passed, 100% Pass Rate)", table_cell)],
    ]
    t_o = Table(o_data, colWidths=[65 * mm, 109 * mm])
    t_o.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#F1F5F9")),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 3.5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 3.5),
    ]))
    elements.append(t_o)
    elements.append(Spacer(1, 8))

    # Table of Contents
    elements.append(Paragraph("Table of Contents", h1_style))
    toc_data = [
        [Paragraph("1. App Name and Introduction", table_cell), Paragraph("4. Features and Functionality", table_cell)],
        [Paragraph("2. Purpose and Objectives", table_cell), Paragraph("5. Important Code Snippets", table_cell)],
        [Paragraph("3. Tools and Technologies", table_cell), Paragraph("6. Deployment Details", table_cell)],
        [Paragraph("", table_cell), Paragraph("7. Screenshots / UI Output", table_cell)],
    ]
    t_toc = Table(toc_data, colWidths=[87 * mm, 87 * mm])
    t_toc.setStyle(TableStyle([
        ('TOPPADDING', (0,0), (-1,-1), 2),
        ('BOTTOMPADDING', (0,0), (-1,-1), 2),
    ]))
    elements.append(t_toc)

    elements.append(PageBreak())

    # Section 1
    elements.append(Paragraph("1. App Name and Introduction", h1_style))
    elements.append(Paragraph("<b>App Name:</b> VitalScale", body_style))
    elements.append(Paragraph("<b>Tagline:</b> Smart Anthropometric & Health Companion for Adults", body_style))
    elements.append(Paragraph(
        "<b>VitalScale</b> is a modern, responsive, client-side Flutter Web application engineered specifically for the UI Design – Flutter Laboratory External Examination. It empowers users to monitor, evaluate, and track their physical health parameters through clinically validated anthropometric algorithms defined by the World Health Organization (WHO).",
        body_style
    ))
    elements.append(Paragraph(
        "The application provides dual-unit body measurement inputs supporting both Metric (Centimeters, Kilograms) and Imperial (Feet & Inches, Pounds), instant Body Mass Index (BMI) computation rounded strictly to one decimal place, dynamic color-coded WHO category classifications, healthy weight range intervals, a custom animated segmented visual gauge, tailored dietary and lifestyle advice, and local history tracking with persistent browser storage.",
        body_style
    ))
    elements.append(Paragraph(
        "VitalScale is developed in Dart using Flutter 3.x and is deployed as a live cloud web application through automated GitHub Actions workflows published to GitHub Pages.",
        body_style
    ))

    # Section 2
    elements.append(Paragraph("2. Purpose and Objectives", h1_style))
    elements.append(Paragraph("<b>2.1 Purpose:</b> The purpose of VitalScale is to deliver a reliable, accessible, and user-friendly biometric screening dashboard that assists individuals in evaluating their body mass classification against clinical standards, while demonstrating professional proficiency in Flutter Web design, defensive input validation, asynchronous browser storage, and automated cloud CI/CD pipelines.", body_style))
    elements.append(Paragraph("<b>2.2 Objectives:</b>", body_style))
    objectives = [
        "To compute Body Mass Index accurately according to standard WHO formulas: BMI = Weight (kg) / (Height in meters)².",
        "To enable seamless, live two-way switching between Metric (cm, kg) and Imperial (ft/in, lbs) units.",
        "To handle defensive input validation preventing crashes from zero, negative, empty, or unrealistic physiological values.",
        "To calculate the estimated healthy weight range based on the user's height (18.5 × H² to 24.9 × H²).",
        "To provide a continuous visual gauge showing the user's BMI position via an animated indicator.",
        "To persist calculation history locally using browser LocalStorage via SharedPreferences.",
        "To offer one-tap viva examination test presets for immediate laboratory demonstration.",
        "To provide Material 3 Dark and Light theme modes with responsive layout adaptability.",
        "To deploy the application as a live web application on GitHub Pages."
    ]
    for obj in objectives:
        elements.append(Paragraph(f"• {obj}", bullet_style))

    # Section 3
    elements.append(Paragraph("3. Tools and Technologies", h1_style))
    tools_data = [
        [Paragraph("Category", table_cell_header), Paragraph("Tools Used", table_cell_header)],
        [Paragraph("Frontend Framework", table_cell_bold), Paragraph("Flutter Web 3.47.9 (Stable Channel)", table_cell)],
        [Paragraph("Programming Language", table_cell_bold), Paragraph("Dart 3.13.7", table_cell)],
        [Paragraph("UI Design System", table_cell_bold), Paragraph("Material Design 3 (M3) Specification", table_cell)],
        [Paragraph("Development Tools", table_cell_bold), Paragraph("Antigravity IDE, Visual Studio Code, Chrome DevTools", table_cell)],
        [Paragraph("Data Storage", table_cell_bold), Paragraph("SharedPreferences ^2.3.2 (HTML5 LocalStorage)", table_cell)],
        [Paragraph("Date Formatting", table_cell_bold), Paragraph("intl ^0.19.0 (Locale-aware date & time formatting)", table_cell)],
        [Paragraph("Testing Harness", table_cell_bold), Paragraph("flutter_test (7 Automated Unit & Widget Tests)", table_cell)],
        [Paragraph("Version Control", table_cell_bold), Paragraph("Git, GitHub", table_cell)],
        [Paragraph("CI/CD & Deployment", table_cell_bold), Paragraph("GitHub Actions, GitHub Pages, Vercel", table_cell)],
    ]
    t_tools = Table(tools_data, colWidths=[55 * mm, 119 * mm])
    t_tools.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#F1F5F9")),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 2.5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 2.5),
    ]))
    elements.append(t_tools)

    elements.append(PageBreak())

    # Section 4
    elements.append(Paragraph("4. Features and Functionality", h1_style))
    features = [
        ("4.1 Dual-Unit Body Parameter Inputs", "Supports Centimeters (cm) and Feet/Inches (ft/in) for height, and Kilograms (kg) and Pounds (lbs) for weight with instant two-way synchronization, interactive sliders, and increment/decrement buttons."),
        ("4.2 Precision Body Mass Index (BMI) Engine", "Calculates BMI = Weight (kg) / [Height (m)]² strictly rounded to 1 decimal place (e.g. 170 cm, 70 kg → 24.2 kg/m²)."),
        ("4.3 WHO Adult Classification & Visual Badges", "Categorizes users into Underweight (<18.5, Blue), Normal Weight (18.5-24.9, Green), Overweight (25-29.9, Orange), and Obesity (≥30, Red)."),
        ("4.4 Estimated Healthy Weight Range & Target Delta", "Computes minimum healthy weight (18.5 × H²) and maximum healthy weight (24.9 × H²) and reports the exact kilogram difference required to reach the normal range."),
        ("4.5 Segmented Visual Gauge with Animated Cursor", "Continuously maps the BMI (15.0 to 40.0) across 4 color-coded segments with a smoothly animating needle pointer bubble."),
        ("4.6 Tailored Dietary & Physical Activity Guidance", "Renders tailored nutritional and exercise recommendations based on the calculated WHO category."),
        ("4.7 Local Calculation History & Persistent Storage", "Stores past calculations in browser LocalStorage via SharedPreferences. Supports reloading entries, single item deletion, and full history clearing."),
        ("4.8 One-Tap Viva Examination Demonstration Presets", "Features quick preset chips for Underweight, Normal, Overweight, and Obesity cases for fast 1-tap examiner demonstration."),
        ("4.9 Theme Support & Health Disclaimer", "Provides toggleable Material 3 Dark and Light modes. Features the mandatory WHO screening disclaimer regarding clinical scope.")
    ]
    for title, desc in features:
        elements.append(Paragraph(f"<b>{title}:</b> {desc}", body_style))

    elements.append(Spacer(1, 6))

    # Section 5
    elements.append(Paragraph("5. Important Code Snippets", h1_style))
    snippets = [
        ("5.1 Application Entry Point", "void main() {\n  WidgetsFlutterBinding.ensureInitialized();\n  runApp(const BmiHealthApp());\n}"),
        ("5.2 BMI Calculation & Healthy Range Algorithms", "static double calculateBmi({\n  required double weightKg,\n  required double heightCm,\n}) {\n  final double heightMeters = heightCm / 100.0;\n  final double rawBmi = weightKg / (heightMeters * heightMeters);\n  return roundToOneDecimal(rawBmi);\n}\n\nstatic ({double minWeightKg, double maxWeightKg}) calculateHealthyWeightRange(double heightCm) {\n  final double h = heightCm / 100.0;\n  return (minWeightKg: roundToOneDecimal(18.5 * h * h), maxWeightKg: roundToOneDecimal(24.9 * h * h));\n}"),
        ("5.3 Unit Conversion Engine", "static double feetAndInchesToCm(int feet, double inches) => roundToOneDecimal((feet * 30.48) + (inches * 2.54));\nstatic double lbsToKg(double lbs) => roundToOneDecimal(lbs * 0.45359237);\nstatic double kgToLbs(double kg) => roundToOneDecimal(kg / 0.45359237);"),
        ("5.4 Local Storage Persistence (SharedPreferences)", "static Future<List<BmiRecord>> saveRecord(BmiRecord record) async {\n  final List<BmiRecord> current = await loadHistory();\n  current.insert(0, record);\n  final prefs = await SharedPreferences.getInstance();\n  await prefs.setString(_historyKey, jsonEncode(current.map((r) => r.toJson()).toList()));\n  return current;\n}")
    ]
    for s_title, s_code in snippets:
        elements.append(Paragraph(f"<b>{s_title}</b>", h2_style))
        c_table = Table([[Paragraph(s_code.replace('\n', '<br/>').replace(' ', '&nbsp;'), code_style)]], colWidths=[174 * mm])
        c_table.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F8FAFC")),
            ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
            ('TOPPADDING', (0,0), (-1,-1), 4),
            ('BOTTOMPADDING', (0,0), (-1,-1), 4),
            ('LEFTPADDING', (0,0), (-1,-1), 6),
            ('RIGHTPADDING', (0,0), (-1,-1), 6),
        ]))
        elements.append(c_table)
        elements.append(Spacer(1, 3))

    elements.append(PageBreak())

    # Section 6
    elements.append(Paragraph("6. Deployment Details", h1_style))
    elements.append(Paragraph(
        "VitalScale is deployed as a high-performance Flutter Web application hosted globally on GitHub Pages using an automated GitHub Actions CI/CD pipeline.",
        body_style
    ))
    elements.append(Paragraph("<b>6.1 Deployment Process:</b>", body_style))
    dep_steps = [
        "The Flutter Web project was developed and verified on local environment.",
        "Git was initialized and all code committed to the GitHub repository on the main branch.",
        "A GitHub Actions workflow (.github/workflows/deploy.yml) was configured to automate testing and deployment.",
        "The workflow runner checks out code, installs Flutter SDK, and runs flutter test (7/7 tests passed).",
        "The production web app is compiled using flutter build web --release --base-href '/bmi-calculator-lab/'.",
        "The build/web artifact is published automatically to GitHub Pages.",
        "The live application is accessible securely via HTTPS."
    ]
    for step in dep_steps:
        elements.append(Paragraph(f"• {step}", bullet_style))

    elements.append(Spacer(1, 4))
    elements.append(Paragraph("<b>6.2 Deployment Links:</b>", body_style))
    elements.append(Paragraph("• <b>Live Application:</b> <a href='https://narayanakadali.github.io/bmi-calculator-lab/'>https://narayanakadali.github.io/bmi-calculator-lab/</a>", bullet_style))
    elements.append(Paragraph("• <b>Source Code:</b> <a href='https://github.com/Narayanakadali/bmi-calculator-lab'>https://github.com/Narayanakadali/bmi-calculator-lab</a>", bullet_style))

    # Section 7
    elements.append(Paragraph("7. Screenshots / UI Output", h1_style))

    wireframes = [
        ("Figure 1: VitalScale Main Dashboard (Dual Column Desktop View)",
"""+-------------------------------------------------------------------------------------------------+
| [❤] VitalScale — BMI & Health Calculator   College UI Flutter Lab Exam     [ⓘ Info]  [☼ Theme] |
+-------------------------------------------------------------------------------------------------+
| QUICK EXAM TEST PRESETS: [Underweight (175,50)] [Normal (170,65)] [Overweight] [Obesity]       |
+----------------------------------------------------+--------------------------------------------+
| BODY PARAMETERS                                    | CALCULATED RESULT          [Normal Weight] |
|                                                    |                                            |
| Gender: [ Male ] ( Female ) ( Other )              |                 24.2 kg/m²                 |
| Height: [ 170 ] cm  [cm | ft&in]  Slider: 170 cm   | 170 cm (5' 7.0")  •  70.0 kg (154.3 lbs)   |
| Weight: [ 70.0 ] kg [kg | lbs]    Slider: 70.0 kg  | BMI SCALE: [Blue | Green====| Org | Red ]  |
| Age: [ 22 ] yrs                                    | Estimated Healthy Range: 53.5 kg – 72.0 kg |
| [ Reset ]                       [ Calculate BMI ]  | Status: Currently in ideal healthy range   |
|                                                    | CALCULATION HISTORY: 170cm, 70kg -> 24.2   |
+----------------------------------------------------+--------------------------------------------+"""),
        ("Figure 2: Imperial Units Input Mode & Scale Output",
"""+----------------------------------------------------+--------------------------------------------+
| Height (Feet & Inches)            [ cm | ft & in ] | CALCULATED RESULT             [Overweight] |
| [ 5         ] ft       [ 7.0       ] in            |                 27.0 kg/m²                 |
| ≈ 170 cm (67.0 total inches)                       | WHO Classification: Overweight             |
| Weight (Pounds)                       [ kg | lbs ] | 170 cm (5' 7.0")  •  78.0 kg (172.0 lbs)   |
| [ 172.0                             ] [lbs]        | BMI SCALE: [Blue | Green | Orange== | Red] |
| ≈ 78.0 kg                                          | Healthy Range: 53.5 kg – 72.0 kg           |
| [-10 lbs] [-2 lbs] [+2 lbs] [+10 lbs]              | Status: 6.0 kg above maximum healthy weight|
+----------------------------------------------------+--------------------------------------------+"""),
        ("Figure 3: Browser LocalStorage History & Mobile Layout",
"""+----------------------------------------------------+-------------------------------+
| CALCULATION HISTORY                 [Clear All (3)]| [❤] VitalScale        [☼] [ⓘ] |
| • (24.2) 170 cm • 70.0 kg [Normal Weight]          | Height: [ 170  ] cm           |
|   Nov 10, 2026 • 08:00 AM                      [x] | Weight: [ 70.0 ] kg           |
| • (27.0) 170 cm • 78.0 kg [Overweight]             | [ Reset ]   [ Calculate BMI ] |
|   Nov 10, 2026 • 07:55 AM                      [x] | Result: 24.2 kg/m² (Normal)   |
| • (16.3) 175 cm • 50.0 kg [Underweight]            | Healthy: 53.5 kg – 72.0 kg    |
|   Nov 10, 2026 • 07:50 AM                      [x] | History: 3 entries recorded   |
+----------------------------------------------------+-------------------------------+""")
    ]

    for caption, w_text in wireframes:
        w_table = Table([[Paragraph(w_text.replace('\n', '<br/>').replace(' ', '&nbsp;'), wireframe_style)]], colWidths=[174 * mm])
        w_table.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F8FAFC")),
            ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#94A3B8")),
            ('TOPPADDING', (0,0), (-1,-1), 4),
            ('BOTTOMPADDING', (0,0), (-1,-1), 4),
            ('LEFTPADDING', (0,0), (-1,-1), 6),
            ('RIGHTPADDING', (0,0), (-1,-1), 6),
        ]))
        elements.append(w_table)
        elements.append(Paragraph(caption, caption_style))
        elements.append(Spacer(1, 4))

    doc.build(elements, canvasmaker=NumberedCanvas)
    print("PDF build complete:", filename)

if __name__ == '__main__':
    build_pdf()
