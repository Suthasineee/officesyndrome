import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_syndrome/helper/colors.dart';

enum UnitSystem { metric, imperial }

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();

  UnitSystem _unit = UnitSystem.metric;
  bool _useAsianCutoff = true;

  @override
  void dispose() {
    weightCtrl.dispose();
    heightCtrl.dispose();
    super.dispose();
  }

  double? _parse(String s) => double.tryParse(s.replaceAll(',', '.'));

  double? _calcBmi() {
    final w = _parse(weightCtrl.text);
    final h = _parse(heightCtrl.text);
    if (w == null || h == null || w <= 0 || h <= 0) return null;

    // แปลงเป็นหน่วยสากลก่อนคำนวณ (kg & m)
    final kg = _unit == UnitSystem.metric ? w : w * 0.45359237; // lb -> kg
    final m = _unit == UnitSystem.metric
        ? (h / 100.0)
        : (h * 0.0254); // in -> m
    if (m == 0) return null;
    return kg / (m * m);
  }

  // คืน (label, color)
  (String, Color) _classify(double bmi) {
    if (_useAsianCutoff) {
      if (bmi < 18.5) return ('น้ำหนักน้อย (Underweight)', Colors.blue);
      if (bmi < 23) return ('ปกติ (Normal)', Colors.green);
      if (bmi < 25) return ('ท้วม/เสี่ยง (Overweight)', Colors.orange);
      if (bmi < 30) return ('อ้วนระดับ 1 (Obese I)', Colors.deepOrange);
      return ('อ้วนระดับ 2 (Obese II)', Colors.red);
    } else {
      if (bmi < 18.5) return ('Underweight', Colors.blue);
      if (bmi < 25) return ('Normal', Colors.green);
      if (bmi < 30) return ('Overweight', Colors.orange);
      if (bmi < 35) return ('Obesity I', Colors.deepOrange);
      if (bmi < 40) return ('Obesity II', Colors.red);
      return ('Obesity III', Colors.red.shade900);
    }
  }

  String _fmt(num x, {int digits = 2}) => x
      .toStringAsFixed(digits)
      .replaceAll(RegExp(r'\.?0+$'), (digits == 0) ? '' : '');

  // ช่วงน้ำหนักเหมาะสมตามส่วนสูง
  String? _idealWeightRange() {
    final h = _parse(heightCtrl.text);
    if (h == null || h <= 0) return null;

    // ใช้ช่วง BMI มาตรฐานของแต่ละเกณฑ์
    final minBmi = 18.5;
    final maxBmi = _useAsianCutoff ? 22.9 : 24.9;

    final m = _unit == UnitSystem.metric ? (h / 100.0) : (h * 0.0254);
    final minKg = minBmi * m * m;
    final maxKg = maxBmi * m * m;

    if (_unit == UnitSystem.metric) {
      return '${_fmt(minKg)}–${_fmt(maxKg)} กก.';
    } else {
      final minLb = minKg / 0.45359237;
      final maxLb = maxKg / 0.45359237;
      return '${_fmt(minLb)}–${_fmt(maxLb)} ปอนด์';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bmi = _calcBmi();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('คำนวณ BMI'),
        backgroundColor: colorPrimary,
      ),
      // backgroundColor: colorPrimary,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // หน่วย
          Text('หน่วย', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('กก./ซม.'),
                selected: _unit == UnitSystem.metric,
                onSelected: (_) => setState(() => _unit = UnitSystem.metric),
              ),
              ChoiceChip(
                label: const Text('ปอนด์/นิ้ว'),
                selected: _unit == UnitSystem.imperial,
                onSelected: (_) => setState(() => _unit = UnitSystem.imperial),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // เกณฑ์
          SwitchListTile.adaptive(
            title: const Text('ใช้เกณฑ์เอเชีย (แนะนำสำหรับผู้ใช้ไทย)'),
            value: _useAsianCutoff,
            onChanged: (v) => setState(() => _useAsianCutoff = v),
          ),
          const SizedBox(height: 8),

          // น้ำหนัก
          TextField(
            controller: weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: _unit == UnitSystem.metric
                  ? 'น้ำหนัก (กก.)'
                  : 'น้ำหนัก (ปอนด์)',
              hintText: _unit == UnitSystem.metric ? 'เช่น 60.5' : 'เช่น 150',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.monitor_weight),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),

          // ส่วนสูง
          TextField(
            controller: heightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: _unit == UnitSystem.metric
                  ? 'ส่วนสูง (ซม.)'
                  : 'ส่วนสูง (นิ้ว)',
              hintText: _unit == UnitSystem.metric ? 'เช่น 165' : 'เช่น 65',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.height),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),

          // ผลลัพธ์
          if (bmi == null) ...[
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('กรอกน้ำหนักและส่วนสูงเพื่อคำนวณ BMI'),
              ),
            ),
          ] else ...[
            Builder(
              builder: (_) {
                final (label, color) = _classify(bmi);
                final ideal = _idealWeightRange();
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('BMI ของคุณ', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(
                          _fmt(bmi),
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(
                            label,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: color,
                        ),
                        const SizedBox(height: 12),
                        if (ideal != null)
                          Text(
                            'ช่วงน้ำหนักที่เหมาะสมตามส่วนสูง: $ideal',
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        _AdviceText(bmi: bmi, useAsian: _useAsianCutoff),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],

          const SizedBox(height: 8),
          Text(
            'ข้อจำกัด: BMI ไม่ได้คำนึงถึงมวลกล้ามเนื้อ อายุ เพศ และองค์ประกอบร่างกายอื่น ๆ '
            'ควรใช้ร่วมกับการประเมินสุขภาพจากผู้เชี่ยวชาญ',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }
}

class _AdviceText extends StatelessWidget {
  final double bmi;
  final bool useAsian;
  const _AdviceText({required this.bmi, required this.useAsian});

  @override
  Widget build(BuildContext context) {
    String msg;
    if (useAsian) {
      if (bmi < 18.5) {
        msg = 'น้ำหนักน้อย: เพิ่มโปรตีน พลังงาน และฝึกเวทเทรนนิงอย่างเหมาะสม';
      } else if (bmi < 23) {
        msg = 'น้ำหนักปกติ: รักษาพฤติกรรมการกินและการออกกำลังกายต่อเนื่อง';
      } else if (bmi < 25) {
        msg =
            'เริ่มเสี่ยง: ลดหวาน มัน เค็ม เพิ่มผักผลไม้ และขยับร่างกายให้สม่ำเสมอ';
      } else if (bmi < 30) {
        msg =
            'อ้วนระดับ 1: ปรึกษานักโภชนาการ/แพทย์ ปรับโภชนาการและกิจกรรมทางกาย';
      } else {
        msg = 'อ้วนระดับ 2: ควรพบแพทย์เพื่อวางแผนลดน้ำหนักอย่างปลอดภัย';
      }
    } else {
      if (bmi < 18.5) {
        msg =
            'Underweight: consider higher-calorie, protein-rich diet and strength training.';
      } else if (bmi < 25) {
        msg = 'Normal: maintain balanced diet and regular activity.';
      } else if (bmi < 30) {
        msg = 'Overweight: reduce calorie-dense foods, increase activity.';
      } else if (bmi < 35) {
        msg = 'Obesity I: seek professional guidance for structured plan.';
      } else {
        msg =
            'Obesity II/III: consult a physician for comprehensive management.';
      }
    }
    return Text(msg, textAlign: TextAlign.center);
  }
}
