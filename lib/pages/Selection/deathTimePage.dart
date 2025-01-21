import 'package:flutter/material.dart';

class DeathTimePage extends StatefulWidget {
  final Function(String) onSelected; // Callback สำหรับส่งค่าที่เลือก

  const DeathTimePage({super.key, required this.onSelected});

  @override
  State<DeathTimePage> createState() => _DeathTimePageState();
}

class _DeathTimePageState extends State<DeathTimePage> {
  final List<Map<String, String>> times = [
    {'key': '0', 'value': 'เที่ยงคืน'},
    {'key': '3', 'value': 'ตี 3'},
    {'key': '6', 'value': '6 โมงเช้า'},
    {'key': '9', 'value': '9 โมงเช้า'},
    {'key': '12', 'value': 'เที่ยงวัน'},
    {'key': '15', 'value': 'บ่าย 3'},
    {'key': '18', 'value': '6 โมงเย็น'},
    {'key': '21', 'value': '3 ทุ่ม'},
    {
      'key': '-1',
      'value': 'กำหนดเวลาเอง'
    }, // ใช้ค่าลบหรือค่าพิเศษที่ไม่ได้อยู่ในช่วงเวลาเพื่อบอกว่าเป็นเวลาที่กำหนดเอง
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
                'กรุณาป้อนเวลาในรูปแบบ 24 ชั่วโมง (HH:MM)',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
                    selectedTime = customTime; // บันทึกเวลาในรูปแบบ 24 ชั่วโมง
                  });
                  widget.onSelected(customTime);
                  Navigator.pop(context);
                } else {
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

  bool _validateTime(String hour, String minute) {
    if (hour.length != 2 || minute.length != 2) return false; // ตรวจสอบความยาว

    final hourValue = int.tryParse(hour);
    final minuteValue = int.tryParse(minute);

    if (hourValue == null || minuteValue == null) return false; // ตรวจสอบตัวเลข
    if (hourValue < 0 || hourValue > 23)
      return false; // ชั่วโมงต้องอยู่ระหว่าง 0-23
    if (minuteValue < 0 || minuteValue > 59)
      return false; // นาทีต้องอยู่ระหว่าง 0-59

    return true; // ถ้าผ่านเงื่อนไขทั้งหมด
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
              if (selectedTime != null)
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
                final timeKey = times[index]['key'];
                final timeValue = times[index]['value'];
                final isSelected = timeValue == selectedTime;
                return GestureDetector(
                  onTap: () {
                    if (timeValue == 'กำหนดเวลาเอง') {
                      _showCustomTimeDialog();
                    } else {
                      setState(() {
                        selectedTime = timeValue;
                      });
                      // เพิ่ม print เพื่อตรวจสอบค่า
                      print('Selected Key: $timeKey');
                      print('Selected Value: $timeValue');
                      widget.onSelected(timeValue!);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange[100] : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.grey,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      timeValue!,
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
