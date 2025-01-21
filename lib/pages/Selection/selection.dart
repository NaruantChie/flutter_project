import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_countdown/pages/Selection/deathDayPage.dart';
import 'package:life_countdown/pages/Selection/deathMonthPage.dart';
import 'package:life_countdown/pages/Selection/deathTimePage.dart';
import 'package:life_countdown/pages/Selection/deathYearPage.dart';

class SelectionPage extends StatefulWidget {
  final String? year;
  final String? month;
  final String? day;
  final Function(Map<String, dynamic>) onNext;

  const SelectionPage({
    super.key,
    this.year,
    this.month,
    this.day,
    required this.onNext,
  });

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage>
    with SingleTickerProviderStateMixin {
  int topSheetIndex = 3; // กำหนดแผ่นที่ 4 อยู่บนสุดเริ่มต้น
  String selectedYear = "";
  String selectedMonth = "";
  String selectedDay = "";
  String selectedTime = "";
  int? selectedMonthNumber; // เก็บเลขเดือนที่เลือก (1-12)

  late AnimationController _imageController;
  late Animation<double> _imageAnimation;

  final List<Map<String, dynamic>> months = [
    {'key': 1, 'value': 'มกราคม'},
    {'key': 2, 'value': 'กุมภาพันธ์'},
    {'key': 3, 'value': 'มีนาคม'},
    {'key': 4, 'value': 'เมษายน'},
    {'key': 5, 'value': 'พฤษภาคม'},
    {'key': 6, 'value': 'มิถุนายน'},
    {'key': 7, 'value': 'กรกฎาคม'},
    {'key': 8, 'value': 'สิงหาคม'},
    {'key': 9, 'value': 'กันยายน'},
    {'key': 10, 'value': 'ตุลาคม'},
    {'key': 11, 'value': 'พฤศจิกายน'},
    {'key': 12, 'value': 'ธันวาคม'},
  ];
  final List<Map<String, String>> times = [
    {'key': '0', 'value': 'เที่ยงคืน'},
    {'key': '3', 'value': 'ตี 3'},
    {'key': '6', 'value': '6 โมงเช้า'},
    {'key': '9', 'value': '9 โมงเช้า'},
    {'key': '12', 'value': 'เที่ยงวัน'},
    {'key': '15', 'value': 'บ่าย 3'},
    {'key': '18', 'value': '6 โมงเย็น'},
    {'key': '21', 'value': '3 ทุ่ม'},
    {'key': '-1', 'value': 'กำหนดเวลาเอง'},
  ];

  @override
  void initState() {
    super.initState();
    selectedYear = widget.year ?? "";
    selectedMonth = widget.month ?? "";
    selectedDay = widget.day ?? "";

    // AnimationController สำหรับ Progress Bar และรูปภาพ
    _imageController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 1200), // กำหนดความเร็วของการเคลื่อนที่
    )..repeat(reverse: true); // เพิ่มการดิ้นของรูปภาพ

    _imageAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _imageController.dispose(); // ปิด AnimationController เมื่อ State ถูกทำลาย
    super.dispose();
  }

  void printSelectedTime(String key) {
    final selectedTimeEntry = times.firstWhere(
      (time) => time['key'] == key,
      orElse: () => {'key': key, 'value': 'ไม่พบข้อมูล'},
    );

    print('Selected Key: ${selectedTimeEntry['key']}');
    print('Selected Value: ${selectedTimeEntry['value']}');
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sheets = [
      {
        'title': 'แผ่นที่ 1',
        'color': Theme.of(context).brightness == Brightness.light
            ? Colors.grey[900]
            : const Color.fromARGB(255, 166, 166, 166),
        'icon': Icons.timer,
        'iconTop': 100.0, // ความสูงของไอคอนสำหรับแผ่นที่ 1
        'maxChildSize': 0.9,
        'initialChildSize': 0.9,
        'minChildSize': 0.3,
        'isDeathTimePage': true,
      },
      {
        'title': 'แผ่นที่ 2',
        'color': Theme.of(context).brightness == Brightness.light
            ? Colors.grey[900]
            : const Color.fromARGB(255, 166, 166, 166),
        'icon': Icons.calendar_today,
        'iconTop': 20.0, // ความสูงของไอคอนสำหรับแผ่นที่ 2
        'maxChildSize': 0.8,
        'initialChildSize': 0.8,
        'minChildSize': 0.3,
        'isDeathDayPage': true,
      },
      {
        'title': 'แผ่นที่ 3',
        'color': Theme.of(context).brightness == Brightness.light
            ? Colors.grey[900]
            : const Color.fromARGB(255, 166, 166, 166),
        'icon': Icons.event_note,
        'iconTop': 40.0, // ความสูงของไอคอนสำหรับแผ่นที่ 3
        'maxChildSize': 0.7,
        'initialChildSize': 0.7,
        'minChildSize': 0.3,
        'isDeathMonthPage': true,
      },
      {
        'title': 'แผ่นที่ 4',
        'color': Theme.of(context).brightness == Brightness.light
            ? Colors.grey[900]
            : const Color.fromARGB(255, 166, 166, 166),
        'icon': Icons.star,
        'iconTop': 50.0, // ความสูงของไอคอนสำหรับแผ่นที่ 4
        'maxChildSize': 0.6,
        'initialChildSize': 0.6,
        'minChildSize': 0.3,
        'isDeathYearPage': true,
      },
    ];

    void bringNextSheetToFront() {
      setState(() {
        topSheetIndex = (topSheetIndex - 1 + sheets.length) % sheets.length;
      });
    }

    void bringPreviousSheetToFront() {
      setState(() {
        topSheetIndex = (topSheetIndex + 1) % sheets.length;
      });
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isConfirmButtonEnabled = (topSheetIndex == 3 &&
            selectedYear.isNotEmpty) || // ต้องเลือกปี
        (topSheetIndex == 2 && selectedMonth.isNotEmpty) || // ต้องเลือกเดือน
        (topSheetIndex == 1 &&
            selectedDay.isNotEmpty &&
            selectedMonthNumber != null) || // ต้องเลือกวันและมีเดือน
        (topSheetIndex == 0 && selectedTime.isNotEmpty); // ต้องเลือกเวลา

    final bool isBackButtonEnabled = topSheetIndex < 3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          "กลับ",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            context.go('/description');
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: kToolbarHeight - 40,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // พื้นหลังของ Progress Bar
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Progress Bar ที่มีไล่สีแดง
                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 500), // ระยะเวลาเคลื่อนที่
                  curve: Curves.easeInOut,
                  width: MediaQuery.of(context).size.width *
                      0.8 *
                      ((sheets.length - topSheetIndex) / sheets.length),
                  height: 35,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 235, 86, 76).withOpacity(0.3),
                        const Color.fromARGB(255, 212, 49, 37).withOpacity(0.6),
                        const Color.fromARGB(255, 159, 20, 10).withOpacity(1.0),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // รูปภาพที่เคลื่อนที่ไปพร้อมกับ Progress Bar
                AnimatedBuilder(
                  animation: _imageController,
                  builder: (context, child) {
                    // คำนวณตำแหน่ง Progress Bar
                    final double progressWidth =
                        MediaQuery.of(context).size.width *
                            0.8 *
                            ((sheets.length - topSheetIndex) / sheets.length);

                    return Transform.translate(
                      // ตำแหน่งรูปภาพสัมพันธ์กับ Progress Bar พร้อมกับ Animation
                      offset: Offset(
                          progressWidth - 25 + _imageAnimation.value, -15),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/images/scared_2367127.png',
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: DraggableScrollableSheet(
              key: ValueKey<int>(topSheetIndex),
              initialChildSize: sheets[topSheetIndex]['initialChildSize'],
              minChildSize: sheets[topSheetIndex]['minChildSize'],
              maxChildSize: sheets[topSheetIndex]['maxChildSize'],
              builder:
                  (BuildContext context, ScrollController scrollController) {
                final isDarkMode =
                    Theme.of(context).brightness == Brightness.dark;

                final isDeathYearPage =
                    sheets[topSheetIndex]['isDeathYearPage'] ?? false;
                final isDeathMonthPage =
                    sheets[topSheetIndex]['isDeathMonthPage'] ?? false;
                final isDeathDayPage =
                    sheets[topSheetIndex]['isDeathDayPage'] ?? false;
                final isDeathTimePage =
                    sheets[topSheetIndex]['isDeathTimePage'] ?? false;

                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 10, sigmaY: 10), // ปรับระดับความเบลอ
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white
                                .withOpacity(0.7) // กระจกสีขาวใสใน Dark Mode
                            : Colors.black
                                .withOpacity(0.2), // กระจกสีดำใสใน Light Mode
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white
                                  .withOpacity(0.8) // เส้นขอบสีขาวใน Dark Mode
                              : Colors.black
                                  .withOpacity(0.5), // เส้นขอบสีดำใน Light Mode
                          width: 1,
                        ),
                        boxShadow: [
                          // เงารอบด้าน
                          BoxShadow(
                            color: isDarkMode
                                ? const Color.fromARGB(255, 212, 202, 202)
                                    .withOpacity(0.8) // เงาสีดำใน Dark Mode
                                : Colors.white
                                    .withOpacity(0.5), // เงาสีขาวใน Light Mode
                            blurRadius: 20,
                            spreadRadius: 5, // ขยายพื้นที่เงา
                            offset: const Offset(0, 10), // เงาอยู่รอบด้าน
                          ),
                          // เงาที่ด้านบน
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.black
                                    .withOpacity(0.2) // เงาสีดำใน Dark Mode
                                : const Color.fromARGB(255, 14, 14, 14)
                                    .withOpacity(0.4), // เงาสีขาวใน Light Mode
                            blurRadius: 10,
                            offset: const Offset(0, -4), // เงาชี้ขึ้น (Y ติดลบ)
                          ),
                          // เงาที่ด้านล่าง
                          BoxShadow(
                            color: isDarkMode
                                ? const Color.fromARGB(255, 155, 153, 153)
                                    .withOpacity(0.2) // เงาสีดำใน Dark Mode
                                : const Color.fromARGB(255, 20, 19, 19)
                                    .withOpacity(0.8), // เงาสีขาวใน Light Mode
                            blurRadius: 15,
                            offset: const Offset(0, 6), // เงาชี้ลง (Y เป็นบวก)
                          ),
                        ],
                      ),
                      child: isDeathYearPage
                          ? DeathYearPage(
                              onSelected: (value) {
                                setState(() {
                                  selectedYear = value.toString();
                                });
                              },
                              birthYear: int.tryParse(widget.year ?? '') ?? 0,
                            )
                          : isDeathMonthPage
                              ? DeathMonthPage(
                                  onSelected: (monthNumber) {
                                    setState(() {
                                      selectedMonthNumber = monthNumber;
                                      selectedMonth = months.firstWhere((m) =>
                                              m['key'] == monthNumber)['value']
                                          as String;
                                    });
                                  },
                                )
                              : isDeathDayPage
                                  ? (selectedMonthNumber != null
                                      ? DeathDayPage(
                                          month: selectedMonthNumber!,
                                          monthName: selectedMonth!,
                                          year: selectedYear.isEmpty
                                              ? 2025
                                              : int.parse(selectedYear),
                                          onSelected: (value) {
                                            setState(() {
                                              selectedDay = value;
                                            });
                                          },
                                        )
                                      : const Center(
                                          child: Text(
                                            'กรุณาเลือกเดือนก่อน',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red),
                                          ),
                                        ))
                                  : isDeathTimePage
                                      ? DeathTimePage(
                                          onSelected: (value) {
                                            setState(() {
                                              selectedTime = value;
                                              printSelectedTime(value);
                                            });
                                          },
                                        )
                                      : Center(
                                          child: Text(
                                            sheets[topSheetIndex]['title'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: isConfirmButtonEnabled
                    ? () {
                        if (topSheetIndex == 3) {
                          setState(() {
                            topSheetIndex = 2;
                          });
                        } else if (topSheetIndex == 2) {
                          setState(() {
                            topSheetIndex = 1;
                          });
                        } else if (topSheetIndex == 1) {
                          setState(() {
                            topSheetIndex = 0;
                          });
                        } else if (topSheetIndex == 0) {
                          context.go(
                            '/resultPage',
                            extra: {
                              'fromSelectDate': {
                                'year': widget.year,
                                'month': widget.month,
                                'day': widget.day,
                              },
                              'fromSelectionPage': {
                                'selectedYear': selectedYear,
                                'selectedMonth': selectedMonth,
                                'selectedMonthNumber': selectedMonthNumber,
                                'selectedDay': selectedDay,
                                'selectedTime': selectedTime,
                                'times': times,
                              },
                              'summary':
                                  'วันที่เลือก: $selectedDay $selectedMonth ($selectedMonthNumber) พ.ศ. $selectedYear เวลา: $selectedTime',
                            },
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isConfirmButtonEnabled ? Colors.blue : Colors.grey,
                ),
                child: Text(
                  topSheetIndex == 3 && selectedYear.isNotEmpty
                      ? "ตกลง (ไปยังเดือน)"
                      : topSheetIndex == 2 && selectedMonth.isNotEmpty
                          ? "ตกลง (ไปยังวัน)"
                          : topSheetIndex == 1 &&
                                  selectedDay.isNotEmpty &&
                                  selectedMonthNumber != null
                              ? "ตกลง (ไปยังเวลา)"
                              : topSheetIndex == 0 && selectedTime.isNotEmpty
                                  ? "ยืนยันข้อมูล"
                                  : "กรุณาเลือกรายการให้ครบ",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),

          // ภายใน Positioned ที่มีปุ่มย้อนกลับ
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: isBackButtonEnabled
                    ? () {
                        bringPreviousSheetToFront();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isBackButtonEnabled ? Colors.blue : Colors.grey,
                ),
                child: const Text(
                  "ย้อนกลับ",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
