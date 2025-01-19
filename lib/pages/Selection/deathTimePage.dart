import 'package:flutter/material.dart';

class DeathTimePage extends StatelessWidget {
  final List<String> times = [
    'เที่ยงคืน',
    'ตี 3',
    '6 โมงเช้า',
    '9 โมงเช้า',
    'เที่ยงวัน',
    'บ่าย 3',
    '6 โมงเย็น',
    '3 ทุ่ม',
    'กำหนดเวลาเอง',
  ];

  DeathTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'เวลาตาย',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none, // ปิดการแสดงเส้นใต้
                ),
              ),
              SizedBox(height: 8),
              Text(
                'คุณคิดว่าคุณจะตายเวลาใด?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                  decoration: TextDecoration.none, // ปิดการแสดงเส้นใต้
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // สร้าง 2 คอลัมน์
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3.5, // อัตราส่วนความยาวปุ่ม
              ),
              itemCount: times.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print('เลือกเวลา: ${times[index]}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      times[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: DeathTimePage(), // ใช้ใน Scaffold เพื่อทดสอบใน main
    ),
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
  ));
}
