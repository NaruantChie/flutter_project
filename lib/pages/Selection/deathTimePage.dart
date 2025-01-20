import 'package:flutter/material.dart';

class DeathTimePage extends StatefulWidget {
  final Function(String) onSelected; // Callback สำหรับส่งค่าที่เลือก

  const DeathTimePage({super.key, required this.onSelected});

  @override
  State<DeathTimePage> createState() => _DeathTimePageState();
}

class _DeathTimePageState extends State<DeathTimePage> {
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

  String? selectedTime; // เก็บเวลาที่เลือก

  void _showCustomTimeDialog() {
    TextEditingController hourController = TextEditingController();
    TextEditingController minuteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'กำหนดเวลาเอง',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TextField สำหรับกรอกชั่วโมง
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: hourController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                        hintText: 'HH',
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // TextField สำหรับกรอกนาที
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: minuteController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                        hintText: 'MM',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'กรุณาป้อนเวลาในรูปแบบ HH:MM',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิด Dialog โดยไม่บันทึก
              },
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                final hour = hourController.text.trim();
                final minute = minuteController.text.trim();

                if (_validateTime(hour, minute)) {
                  final customTime = '$hour:$minute';
                  setState(() {
                    selectedTime = customTime; // บันทึกเวลาที่กำหนดเอง
                  });
                  widget.onSelected(customTime); // ส่งค่ากลับ
                  Navigator.pop(context); // ปิด Dialog
                } else {
                  // แสดงข้อความเตือนเมื่อรูปแบบเวลาไม่ถูกต้อง
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('รูปแบบเวลาไม่ถูกต้อง'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันตรวจสอบรูปแบบเวลา (ชั่วโมง และ นาที)
  bool _validateTime(String hour, String minute) {
    if (hour.length != 2 || minute.length != 2) return false;

    final hourValue = int.tryParse(hour);
    final minuteValue = int.tryParse(minute);

    if (hourValue == null || minuteValue == null) return false;
    if (hourValue < 0 || hourValue > 23)
      return false; // ชั่วโมงต้องอยู่ในช่วง 0-23
    if (minuteValue < 0 || minuteValue > 59)
      return false; // นาทีต้องอยู่ในช่วง 0-59

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'เวลาตาย',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'คุณคิดว่าคุณจะตายเวลาใด?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                ),
              ),
              if (selectedTime != null) // แสดงเวลาที่เลือก
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'คุณเลือกเวลา: $selectedTime',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
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
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3.5,
              ),
              itemCount: times.length,
              itemBuilder: (context, index) {
                final isSelected = times[index] == selectedTime;
                return GestureDetector(
                  onTap: () {
                    if (times[index] == 'กำหนดเวลาเอง') {
                      _showCustomTimeDialog(); // แสดง Dialog สำหรับกำหนดเวลาเอง
                    } else {
                      setState(() {
                        selectedTime = times[index]; // บันทึกเวลาที่เลือก
                      });
                      widget.onSelected(times[index]); // ส่งค่าที่เลือกกลับ
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange[100] : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: isSelected ? Colors.orange : Colors.grey,
                          width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      times[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.orange : Colors.grey,
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
