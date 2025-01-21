import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultPage extends StatefulWidget {
  final Map<String, dynamic>? fromSelectDate;
  final Map<String, dynamic>? fromSelectionPage;

  const ResultPage({
    super.key,
    this.fromSelectDate,
    this.fromSelectionPage,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int? remainingDays;
  int? remainingYears;
  int? remainingHours;
  int? remainingMinutes;
  int? remainingSeconds;

  int? daysLived;
  int? yearsLived;

  DateTime? birthDate;
  DateTime? deathDate;

  @override
  void initState() {
    super.initState();

    // พิมพ์ค่าของ SelectDatePage เมื่อมาหน้านี้
    print('SelectDatePage Data: ${widget.fromSelectDate}');
    print('SelectionPage Data: ${widget.fromSelectionPage}');
  }

  void calculateRemainingTime() {
    final monthMapping = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
      "มกราคม": 1,
      "กุมภาพันธ์": 2,
      "มีนาคม": 3,
      "เมษายน": 4,
      "พฤษภาคม": 5,
      "มิถุนายน": 6,
      "กรกฎาคม": 7,
      "สิงหาคม": 8,
      "กันยายน": 9,
      "ตุลาคม": 10,
      "พฤศจิกายน": 11,
      "ธันวาคม": 12,
    };

    final timeMapping = {
      "เที่ยงคืน": 0,
      "ตี 3": 3,
      "6 โมงเช้า": 6,
      "9 โมงเช้า": 9,
      "เที่ยงวัน": 12,
      "บ่าย 3": 15,
      "6 โมงเย็น": 18,
      "3 ทุ่ม": 21,
    };

    if (widget.fromSelectDate != null && widget.fromSelectionPage != null) {
      final int birthYear =
          (int.tryParse(widget.fromSelectDate?['year']?.toString() ?? '0') ??
                  0) -
              543;
      final int birthMonth = monthMapping[widget.fromSelectDate?['month']] ?? 1;
      final int birthDay =
          int.tryParse(widget.fromSelectDate?['day']?.toString() ?? '1') ?? 1;

      birthDate = DateTime(birthYear, birthMonth, birthDay);

      final int deathYear = (int.tryParse(
                  widget.fromSelectionPage?['selectedYear']?.toString() ??
                      '0') ??
              0) -
          543;
      final int deathMonth =
          monthMapping[widget.fromSelectionPage?['selectedMonth']] ?? 1;
      final int deathDay = int.tryParse(
              widget.fromSelectionPage?['selectedDay']?.toString() ?? '1') ??
          1;

      // ตรวจสอบและแปลงเวลาที่เลือก
      final String? selectedTime = widget.fromSelectionPage?['selectedTime'];
      int deathHour = 0;
      int deathMinute = 0;

      if (selectedTime != null && timeMapping.containsKey(selectedTime)) {
        // เวลาแบบปกติ เช่น "ตี 3"
        deathHour = timeMapping[selectedTime]!;
      } else if (selectedTime != null && selectedTime.contains(':')) {
        // เวลาแบบกำหนดเอง เช่น "HH:MM"
        final parts = selectedTime.split(':');
        if (parts.length == 2) {
          deathHour = int.tryParse(parts[0]) ?? 0;
          deathMinute = int.tryParse(parts[1]) ?? 0;
        }
      }

      deathDate =
          DateTime(deathYear, deathMonth, deathDay, deathHour, deathMinute);

      final now = DateTime.now();
      final ageDuration = now.difference(birthDate!); // อายุที่ผ่านไปแล้ว
      final remainingDuration =
          deathDate!.difference(now); // เวลาเหลือก่อนถึงวันตาย

      setState(() {
        // คำนวณอายุที่มีอยู่แล้ว
        daysLived = ageDuration.inDays;
        yearsLived = daysLived! ~/ 365;

        // คำนวณอายุที่เหลือ
        remainingDays = remainingDuration.inDays;
        remainingYears = remainingDays! ~/ 365;
        remainingHours = remainingDuration.inHours % 24;
        remainingMinutes = remainingDuration.inMinutes % 60;
        remainingSeconds = remainingDuration.inSeconds % 60;
      });
    }
  }

  void goToLifeCountdownPage() {
    if (birthDate != null && deathDate != null) {
      GoRouter.of(context).go(
        '/lifeCount_downPage',
        extra: {
          'birthDate': birthDate!,
          'deathDate': deathDate!,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากดปุ่มคำนวณก่อน')),
      );
    }
  }

  void goBackToSelection() {
    GoRouter.of(context).go(
      '/selection',
      extra: {
        'fromSelectDate': widget.fromSelectDate,
        'fromSelectionPage': null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: goBackToSelection,
        ),
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
            const Divider(),
            Text('ปี: ${widget.fromSelectDate?['year'] ?? 'ไม่ระบุ'}'),
            Text('เดือน: ${widget.fromSelectDate?['month'] ?? 'ไม่ระบุ'}'),
            Text('วัน: ${widget.fromSelectDate?['day'] ?? 'ไม่ระบุ'}'),
            const Divider(thickness: 1.5, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'ค่าจาก SelectionPage:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(
                'ปีที่เลือก: ${widget.fromSelectionPage?['selectedYear'] ?? 'ไม่ระบุ'}'),
            Text(
                'เดือนที่เลือก: ${widget.fromSelectionPage?['selectedMonth'] ?? 'ไม่ระบุ'}'),
            Text(
                'วันที่เลือก: ${widget.fromSelectionPage?['selectedDay'] ?? 'ไม่ระบุ'}'),
            Text(
                'เวลาที่เลือก: ${widget.fromSelectionPage?['selectedTime'] ?? 'ไม่ระบุ'}'),
            const Divider(thickness: 1.5, color: Colors.grey),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: calculateRemainingTime,
              child: const Text('คำนวณ'),
            ),
            const SizedBox(height: 20),
            if (remainingDays != null && daysLived != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ฉันมีชีวิตมาแล้ว $yearsLived ปี หรือ $daysLived วัน',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ฉันเหลืออีก $remainingYears ปี หรือ $remainingDays วัน',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'เวลาเหลืออีก $remainingHours ชั่วโมง $remainingMinutes นาที $remainingSeconds วินาที',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            else
              const Text(
                'กรุณากดปุ่มเพื่อคำนวณ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: goToLifeCountdownPage,
              child: const Text('ไปหน้า Life Countdown'),
            ),
          ],
        ),
      ),
    );
  }
}
