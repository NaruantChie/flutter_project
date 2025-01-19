import 'package:flutter/material.dart';

class DeathDayPage extends StatefulWidget {
  const DeathDayPage({super.key});

  @override
  State<DeathDayPage> createState() => _DeathDayPageState();
}

class _DeathDayPageState extends State<DeathDayPage> {
  int selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(2025, selectedMonth + 1, 0).day;
    final firstDayOfWeek = DateTime(2025, selectedMonth, 1).weekday;

    final List<String> daysOfWeek = [
      'อา.',
      'จ.',
      'อ.',
      'พ.',
      'พฤ.',
      'ศ.',
      'ส.'
    ];
    final List<Widget> dayWidgets = [];

    // เติมช่องว่างสำหรับวันแรกของเดือน
    for (int i = 0; i < firstDayOfWeek % 7; i++) {
      dayWidgets.add(const SizedBox());
    }

    // สร้างปุ่มสำหรับวันที่
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(GestureDetector(
        onTap: () {
          // เพิ่มฟังก์ชันเมื่อคลิกวันที่
          print('เลือกวันที่22: $day');
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromARGB(255, 13, 10, 5)),
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'วันตาย',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none, // ปิดการแสดงเส้นใต้
                ),
              ),
              SizedBox(height: 8),
              Text(
                'คุณคิดว่าคุณจะตายวันใด?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                  decoration: TextDecoration.none, // ปิดการแสดงเส้นใต้
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: daysOfWeek
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 24,
                            decoration:
                                TextDecoration.none, // ปิดการแสดงเส้นใต้
// ลดขนาดตัวอักษรจากค่าเริ่มต้น
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 7, // 7 วันใน 1 สัปดาห์
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: dayWidgets,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedMonth =
                        (selectedMonth - 1) < 1 ? 12 : selectedMonth - 1;
                  });
                },
                child: const Text("เดือนก่อนหน้า"),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedMonth =
                        (selectedMonth + 1) > 12 ? 1 : selectedMonth + 1;
                  });
                },
                child: const Text("เดือนถัดไป"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: DeathDayPage(), // แทรกใน Scaffold หากต้องการใช้ใน main
    ),
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
  ));
}
