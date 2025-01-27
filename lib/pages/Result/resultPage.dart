import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.calculateButtonMessage),
        ),
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
    final localizations = AppLocalizations.of(context)!; // ดึงข้อมูลที่แปลภาษา

    void calculateRemainingTime() {
      final monthMapping = {
        localizations.january: 1,
        localizations.february: 2,
        localizations.march: 3,
        localizations.april: 4,
        localizations.may: 5,
        localizations.june: 6,
        localizations.july: 7,
        localizations.august: 8,
        localizations.september: 9,
        localizations.october: 10,
        localizations.november: 11,
        localizations.december: 12,
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
        final int birthMonth =
            monthMapping[widget.fromSelectDate?['month']] ?? 1;
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

    // ตรวจสอบโหมดธีมปัจจุบัน
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          AppLocalizations.of(context)!.back,
          style: TextStyle(color: textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: goBackToSelection,
        ),
      ),
      body: Container(
        color: backgroundColor, // กำหนดพื้นหลังเป็นสีดำหรือขาว
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(
                    color: isDarkMode ? Colors.grey : Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.deathDateTimeMessage,
                            style: TextStyle(fontSize: 16.0, color: textColor),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.fromSelectionPage?['selectedDay'] ?? 'ไม่ระบุ'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.fromSelectionPage?['selectedMonth'] ?? 'ไม่ระบุ'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.yearLabel_lv1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: textColor,
                          ),
                        ),
                        Text(
                          '${widget.fromSelectionPage?['selectedYear'] ?? 'ไม่ระบุ'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!
                              .timeLabel, // ดึงข้อความที่แปลจาก localization
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          '${widget.fromSelectionPage?['selectedTime'] ?? 'ไม่ระบุ'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.nextStepMessage,
                            textAlign:
                                TextAlign.center, // จัดข้อความให้อยู่ตรงกลาง
                            style: TextStyle(
                              fontSize: 16.0,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            AppLocalizations.of(context)!
                                .breatheAndPressMessage,
                            textAlign:
                                TextAlign.center, // จัดข้อความให้อยู่ตรงกลาง
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        calculateRemainingTime();
                        if (birthDate != null && deathDate != null) {
                          GoRouter.of(context).go(
                            '/lifeCount_downPage',
                            extra: {
                              'birthDate': birthDate!,
                              'deathDate': deathDate!,
                            },
                          );
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .viewResults, // ดึงข้อความที่แปลจาก localization
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
