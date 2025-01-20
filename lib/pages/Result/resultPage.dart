import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic>? fromSelectDate;
  final Map<String, dynamic>? fromSelectionPage;

  const ResultPage({
    super.key,
    this.fromSelectDate,
    this.fromSelectionPage,
  });

  // Function to convert Buddhist year to Gregorian year
  int? convertToBuddhistYear(int? year) {
    return year != null ? year + 543 : null;
  }

  // Function to convert Gregorian year to Buddhist year
  int? convertToGregorianYear(int? year) {
    return year != null ? year - 543 : null;
  }

  @override
  Widget build(BuildContext context) {
    int? remainingDays;

    // ตรวจสอบข้อมูลก่อนเริ่มคำนวณ
    if (fromSelectDate != null && fromSelectionPage != null) {
      // รับค่าปี เดือน วัน ที่เลือกใน SelectionPage
      final int selectedYear =
          int.tryParse(fromSelectionPage?['selectedYear']?.toString() ?? '0') ??
              0;
      final int selectedMonth = int.tryParse(
              fromSelectionPage?['selectedMonth']?.toString() ?? '1') ??
          1;
      final int selectedDay =
          int.tryParse(fromSelectionPage?['selectedDay']?.toString() ?? '1') ??
              1;

      // แปลงปีพุทธศักราชเป็นคริสต์ศักราช
      final deathDate = DateTime(
        convertToGregorianYear(selectedYear) ?? 0,
        selectedMonth,
        selectedDay,
      );

      // รับค่าปี เดือน วัน วันเกิด
      final int birthYear =
          int.tryParse(fromSelectDate?['year']?.toString() ?? '0') ?? 0;
      final int birthMonth =
          int.tryParse(fromSelectDate?['month']?.toString() ?? '1') ?? 1;
      final int birthDay =
          int.tryParse(fromSelectDate?['day']?.toString() ?? '1') ?? 1;

      final birthDate = DateTime(
        convertToGregorianYear(birthYear) ?? 0,
        birthMonth,
        birthDay,
      );

      // ตรวจสอบว่าข้อมูลวันเกิดและวันที่เสียชีวิตถูกต้อง
      if (!birthDate.isAfter(deathDate)) {
        remainingDays = deathDate.difference(birthDate).inDays;
      }
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
            Text(
                'ปี: ${convertToBuddhistYear(int.tryParse(fromSelectDate?['year']?.toString() ?? '0')) ?? 'ไม่ระบุ'}'),
            Text('เดือน: ${fromSelectDate?['month'] ?? 'ไม่ระบุ'}'),
            Text('วัน: ${fromSelectDate?['day'] ?? 'ไม่ระบุ'}'),
            const SizedBox(height: 16),
            const Text(
              'ค่าจาก SelectionPage:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('ปี: ${fromSelectionPage?['selectedYear'] ?? 'ไม่ระบุ'}'),
            Text('เดือน: ${fromSelectionPage?['selectedMonth'] ?? 'ไม่ระบุ'}'),
            Text('วัน: ${fromSelectionPage?['selectedDay'] ?? 'ไม่ระบุ'}'),
            Text('เวลา: ${fromSelectionPage?['selectedTime'] ?? 'ไม่ระบุ'}'),
            const SizedBox(height: 32),
            if (remainingDays != null)
              Text(
                'เหลืออีก $remainingDays วัน ฉันจะตาย',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
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
