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

  const SelectionPage({
    Key? key,
    this.year,
    this.month,
    this.day,
  }) : super(key: key);
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
  @override
  void initState() {
    super.initState();
    // กำหนดค่าจาก SelectDatePage เป็นค่าเริ่มต้น
    selectedYear = widget.year ?? "";
    selectedMonth = widget.month ?? "";
    selectedDay = widget.day ?? "";
  }
  final List<Map<String, dynamic>> sheets = [
    {
      'title': 'แผ่นที่ 1',
      'color': Colors.green[400],
      'maxChildSize': 0.9,
      'initialChildSize': 0.9,
      'minChildSize': 0.3,
      'isDeathTimePage': true,
    },
    {
      'title': 'แผ่นที่ 2',
      'color': Colors.blue[400],
      'maxChildSize': 0.8,
      'initialChildSize': 0.8,
      'minChildSize': 0.3,
      'isDeathDayPage': true,
    },
    {
      'title': 'แผ่นที่ 3',
      'color': Colors.orange[400],
      'maxChildSize': 0.7,
      'initialChildSize': 0.7,
      'minChildSize': 0.3,
      'isDeathMonthPage': true,
    },
    {
      'title': 'แผ่นที่ 4',
      'color': Colors.purple[400],
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("กลับ"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/description');
          },
        ),
      ),
      body: Stack(
        children: [
          // ด้านล่างสุด (Background)
          Container(
            color: isDarkMode ? Colors.black : Colors.white,
          ),
          // ใช้ AnimatedSwitcher สำหรับเปลี่ยนแผ่นอย่างสมูท
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
                    color: sheets[topSheetIndex]['color'],
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
                        )
                      : isDeathMonthPage
                          ? DeathMonthPage(
                              onSelected: (monthNumber, monthName) {
                                setState(() {
                                  selectedMonthNumber =
                                      monthNumber; // บันทึกเลขเดือน
                                  selectedMonth = monthName; // บันทึกชื่อเดือน
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
                                          selectedDay =
                                              value; // บันทึกวันที่ที่เลือก
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
                                          selectedTime =
                                              value; // บันทึกเวลาที่เลือก
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
          // ปุ่มสลับแผ่นที่ตำแหน่งคงที่
   Positioned(
  bottom: 50,
  left: 0,
  right: 0,
  child: Center(
   child: ElevatedButton(
  onPressed: () {
    if (topSheetIndex == 3 && selectedYear.isNotEmpty) {
      setState(() {
        topSheetIndex = 2; // ไปยังการเลือกเดือน
      });
    } else if (topSheetIndex == 2 && selectedMonth.isNotEmpty) {
      setState(() {
        topSheetIndex = 1; // ไปยังการเลือกวัน
      });
    } else if (topSheetIndex == 1 && selectedDay.isNotEmpty) {
      setState(() {
        topSheetIndex = 0; // ไปยังการเลือกเวลา
      });
    } else if (topSheetIndex == 0 && selectedTime.isNotEmpty) {
      // ส่งข้อมูลทั้งหมดไปยังหน้าผลลัพธ์ รวมค่าจาก SelectDatePage
      context.go(
        '/resultPage',
        extra: {
          'fromSelectDate': {
            'year': widget.year, // ค่าจาก SelectDatePage
            'month': widget.month,
            'day': widget.day,
          },
          'fromSelectionPage': {
            'selectedYear': selectedYear, // ค่าที่เลือกใน SelectionPage
            'selectedMonth': selectedMonth,
            'selectedDay': selectedDay,
            'selectedTime': selectedTime,
          },
          'summary':
              'วันที่เลือก: $selectedDay $selectedMonth พ.ศ. $selectedYear เวลา: $selectedTime',
        },
      );
    } else {
      // แสดงข้อความเตือนหากยังเลือกไม่ครบ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาเลือกรายการให้ครบก่อน'),
        ),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: (topSheetIndex == 3 && selectedYear.isNotEmpty) ||
            (topSheetIndex == 2 && selectedMonth.isNotEmpty) ||
            (topSheetIndex == 1 && selectedDay.isNotEmpty) ||
            (topSheetIndex == 0 && selectedTime.isNotEmpty)
        ? Colors.blue // ใช้สีปกติหากข้อมูลครบ
        : Colors.grey, // ใช้สีเทาหากข้อมูลไม่ครบ
  ),
  child: Text(
    topSheetIndex == 3 && selectedYear.isNotEmpty
        ? "ตกลง (ไปยังเดือน)"
        : topSheetIndex == 2 && selectedMonth.isNotEmpty
            ? "ตกลง (ไปยังวัน)"
            : topSheetIndex == 1 && selectedDay.isNotEmpty
                ? "ตกลง (ไปยังเวลา)"
                : topSheetIndex == 0 && selectedTime.isNotEmpty
                    ? "ยืนยันข้อมูล"
                    : "กรุณาเลือกรายการให้ครบ",
    style: const TextStyle(fontSize: 16, color: Colors.white),
  ),
),

  ),
),

        ],
      ),
    );
  }
}
