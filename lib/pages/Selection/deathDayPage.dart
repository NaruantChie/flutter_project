import 'package:flutter/material.dart';
class DeathDayPage extends StatefulWidget {
  final int month; // เดือนในรูปแบบตัวเลข (1-12)
  final String monthName; // ชื่อเดือน
  final int year; // ปี
  final Function(String) onSelected; // Callback สำหรับส่งวันที่ที่เลือก

  const DeathDayPage({
    super.key,
    required this.month,
    required this.monthName,
    required this.year,
    required this.onSelected,
  });

  @override
  State<DeathDayPage> createState() => _DeathDayPageState();
}

class _DeathDayPageState extends State<DeathDayPage> {
  int? selectedDay;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(widget.year, widget.month + 1, 0).day; // จำนวนวันในเดือน
    final firstDayOfWeek = DateTime(widget.year, widget.month, 1).weekday;

    final List<Widget> dayWidgets = [];

    // เติมช่องว่างสำหรับวันแรกของเดือน
    for (int i = 0; i < firstDayOfWeek % 7; i++) {
      dayWidgets.add(const SizedBox());
    }

    // สร้างปุ่มสำหรับวันที่
    for (int day = 1; day <= daysInMonth; day++) {
      final isSelected = selectedDay == day;
      dayWidgets.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedDay = day;
          });
          widget.onSelected('$day-${widget.month}-${widget.year}');
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange[100] : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isSelected ? Colors.orange : Colors.grey, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.orange : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เลือกวันที่ในเดือน ${widget.monthName} ปี ${widget.year}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 7,
            children: dayWidgets,
          ),
        ),
      ],
    );
  }
}
