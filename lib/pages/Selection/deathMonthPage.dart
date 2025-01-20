import 'package:flutter/material.dart';

class DeathMonthPage extends StatefulWidget {
  final Function(int) onSelected;

  const DeathMonthPage({super.key, required this.onSelected});

  @override
  State<DeathMonthPage> createState() => _DeathMonthPageState();
}

class _DeathMonthPageState extends State<DeathMonthPage> {
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

  int? selectedMonthKey;

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
        if (selectedMonthKey != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'คุณเลือกเดือนที่: $selectedMonthKey',
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
              final month = months[index];
              final isSelected = month['key'] == selectedMonthKey;
              return GestureDetector(
                key: Key(month['key'].toString()),
                onTap: () {
                  setState(() {
                    selectedMonthKey = month['key'];
                  });
                  // เพิ่ม print เพื่อแสดงค่า key ที่เลือก
                  print('Selected key (month number): ${month['key']}');
                  widget.onSelected(month['key']);
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
                    month['value'],
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
