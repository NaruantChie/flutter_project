import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic>? fromSelectDate;
  final Map<String, dynamic>? fromSelectionPage;

  const ResultPage({
    super.key,
    this.fromSelectDate,
    this.fromSelectionPage,
  });

  @override
  Widget build(BuildContext context) {
    int? remainingDays;
    int? remainingHours;
    int? remainingMinutes;
    int? remainingSeconds;

    if (fromSelectDate != null && fromSelectionPage != null) {
      // ดึงข้อมูลจาก SelectDatePage
      final int birthYear =
          int.tryParse(fromSelectDate?['year']?.toString() ?? '0') ?? 0;
      final int birthMonth =
          int.tryParse(fromSelectDate?['month']?.toString() ?? '1') ?? 1;
      final int birthDay =
          int.tryParse(fromSelectDate?['day']?.toString() ?? '1') ?? 1;

      final birthDate = DateTime(birthYear, birthMonth, birthDay);

      // ดึงข้อมูลจาก SelectionPage
      final int additionalYears =
          int.tryParse(fromSelectionPage?['selectedYear']?.toString() ?? '0') ??
              0;
      final int additionalMonths =
          fromSelectionPage?['selectedMonthNumber'] ?? 0;
      final int selectedDay =
          int.tryParse(fromSelectionPage?['selectedDay']?.toString() ?? '1') ??
              1;
      final int additionalHours =
          int.tryParse(fromSelectionPage?['selectedTime']?.toString() ?? '0') ??
              0;

      // ใช้ selectedDay อย่างเหมาะสม โดยบวกจากวันที่เริ่มต้นของเดือน
      final finalDate = birthDate
          .add(Duration(days: additionalYears - 365))
          .add(Duration(days: additionalMonths - 30)) // คร่าวๆ ต่อเดือน
          .add(Duration(hours: additionalHours))
          .add(Duration(days: selectedDay - 1));

      // เวลาปัจจุบัน
      final now = DateTime.now();

      // คำนวณระยะเวลาที่เหลือ
      final remainingDuration = finalDate.difference(now);
      remainingDays = remainingDuration.inDays;
      remainingHours = remainingDuration.inHours % 24;
      remainingMinutes = remainingDuration.inMinutes % 60;
      remainingSeconds = remainingDuration.inSeconds % 60;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ค่าจาก SelectDatePage:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('ปี: ${fromSelectDate?['year'] ?? 'ไม่ระบุ'}'),
            Text('เดือน: ${fromSelectDate?['month'] ?? 'ไม่ระบุ'}'),
            Text('วัน: ${fromSelectDate?['day'] ?? 'ไม่ระบุ'}'),
            const SizedBox(height: 16),
            const Text(
              'ค่าจาก SelectionPage:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('ปี: ${fromSelectionPage?['selectedYear'] ?? 'ไม่ระบุ'}'),
            Text(
                'เลขเดือน: ${fromSelectionPage?['selectedMonthNumber'] ?? 'ไม่ระบุ'}'),
            Text('วัน: ${fromSelectionPage?['selectedDay'] ?? 'ไม่ระบุ'}'),
            Text('เวลา: ${fromSelectionPage?['selectedTime'] ?? 'ไม่ระบุ'}'),
            const SizedBox(height: 32),
            if (remainingDays != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เหลืออีก $remainingDays วัน, $remainingHours ชั่วโมง, $remainingMinutes นาที, $remainingSeconds วินาที ฉันจะตาย',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            else
              const Text(
                'ไม่สามารถคำนวณจำนวนวันที่เหลือได้',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
