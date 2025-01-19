import 'package:flutter/material.dart';

class DeathMonthPage extends StatelessWidget {
  final List<String> months = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];

  DeathMonthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'เดือนตาย',
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
          child: Text(
            'คุณคิดว่าคุณจะตายเดือนใด',
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // สร้าง 2 คอลัมน์
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3, // อัตราส่วนปุ่มให้ยาวตามที่ต้องการ
              ),
              itemCount: months.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // เพิ่มฟังก์ชันการเลือกเดือน
                    print('เลือกเดือน: ${months[index]}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      months[index],
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
