import 'package:flutter/material.dart';

class DeathMonthPage extends StatefulWidget {
  final Function(int, String) onSelected; // เพิ่ม callback ที่ส่งเดือนในรูปตัวเลขและชื่อ

  const DeathMonthPage({super.key, required this.onSelected});

  @override
  State<DeathMonthPage> createState() => _DeathMonthPageState();
}

class _DeathMonthPageState extends State<DeathMonthPage> {
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

  String? selectedMonth; // เก็บเดือนที่เลือก

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
        if (selectedMonth != null) // แสดงเดือนที่เลือก
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'คุณเลือก: $selectedMonth',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3,
            ),
            itemCount: months.length,
            itemBuilder: (context, index) {
              final isSelected = months[index] == selectedMonth;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMonth = months[index];
                  });
                  // ส่งข้อมูลเดือนที่เลือกกลับไป (index + 1 = เดือนในรูปแบบตัวเลข)
                  widget.onSelected(index + 1, months[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange[100] : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.orange : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    months[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.orange : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
