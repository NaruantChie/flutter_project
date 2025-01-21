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

class _SelectionPageState extends State<SelectionPage> {
  int topSheetIndex = 3; // กำหนดแผ่นที่ 4 อยู่บนสุดเริ่มต้น
  String selectedYear = "";
  String selectedMonth = "";
  String selectedDay = "";
  String selectedTime = "";
  int? selectedMonthNumber; // เก็บเลขเดือนที่เลือก (1-12)

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
        'color': Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800] // สีเข้มในโหมดมืด
            : Colors.grey[200], // สีอ่อนในโหมดสว่าง
        'maxChildSize': 0.9,
        'initialChildSize': 0.9,
        'minChildSize': 0.3,
        'isDeathTimePage': true,
      },
      {
        'title': 'แผ่นที่ 2',
        'color': Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[700]
            : Colors.grey[300],
        'maxChildSize': 0.8,
        'initialChildSize': 0.8,
        'minChildSize': 0.3,
        'isDeathDayPage': true,
      },
      {
        'title': 'แผ่นที่ 3',
        'color': Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[600]
            : Colors.grey[400],
        'maxChildSize': 0.7,
        'initialChildSize': 0.7,
        'minChildSize': 0.3,
        'isDeathMonthPage': true,
      },
      {
        'title': 'แผ่นที่ 4',
        'color': Theme.of(context).brightness == Brightness.light
            ? Colors.grey[900]
            : Colors.grey[50],
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

    // เพิ่มฟังก์ชันนำแผ่นก่อนหน้าไปด้านหน้า
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
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900] // พื้นหลังเข้มในโหมดมืด
            : Colors.white, // พื้นหลังอ่อนในโหมดสว่าง
        title: Text(
          "กลับ",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white // ตัวหนังสือสีขาวในโหมดมืด
                : Colors.black, // ตัวหนังสือสีดำในโหมดสว่าง
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white // ไอคอนสีขาวในโหมดมืด
                : Colors.black, // ไอคอนสีดำในโหมดสว่าง
          ),
          onPressed: () {
            context.go('/description'); // กลับไปยังหน้า Description
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: isDarkMode ? Colors.black : Colors.white,
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
                final isDeathYearPage =
                    sheets[topSheetIndex]['isDeathYearPage'] ?? false;
                final isDeathMonthPage =
                    sheets[topSheetIndex]['isDeathMonthPage'] ?? false;
                final isDeathDayPage =
                    sheets[topSheetIndex]['isDeathDayPage'] ?? false;
                final isDeathTimePage =
                    sheets[topSheetIndex]['isDeathTimePage'] ?? false;

                return Container(
                  decoration: BoxDecoration(
                    color: sheets[topSheetIndex]
                        ['color'], // ดึงสีจาก sheets ที่ปรับแล้ว
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
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
                                            fontSize: 18, color: Colors.red),
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
