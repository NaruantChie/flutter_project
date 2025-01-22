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
      'value': 'กำหนดเวลาเอง',
    }, // ใช้ค่าพิเศษเพื่อกำหนดเวลาเอง
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
    if (hour.length != 2 || minute.length != 2) return false;

    final hourValue = int.tryParse(hour);
    final minuteValue = int.tryParse(minute);

    if (hourValue == null || minuteValue == null) return false;
    if (hourValue < 0 || hourValue > 23) return false;
    if (minuteValue < 0 || minuteValue > 59) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryColor = isDarkMode ? Colors.black : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "เวลาตาย",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black // สีขาวในโหมดมืด
                      : Colors.black, // สีดำในโหมดสว่าง
                ),
              ),
              Text(
                "คุณคิดว่าคุณจะตายเวลาใด?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black // สีขาวในโหมดมืด
                      : Colors.black, // สีดำในโหมดสว่าง
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Column(
            children: [
              // ปุ่ม "กำหนดเวลาเอง" แยกออกมาและจัดให้อยู่ตรงกลาง
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: GestureDetector(
                    onTap: _showCustomTimeDialog,
                    child: Container(
                      width: MediaQuery.of(context).size.width *
                          0.8, // ความกว้าง 80% ของหน้าจอ
                      height: 50, // ความสูงของปุ่ม
                      decoration: BoxDecoration(
                        color: selectedTime == 'กำหนดเวลาเอง'
                            ? primaryColor
                            : secondaryColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedTime == 'กำหนดเวลาเอง'
                              ? Colors.grey
                              : secondaryColor,
                          width: selectedTime == 'กำหนดเวลาเอง' ? 3 : 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'กำหนดเวลาเอง',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedTime == 'กำหนดเวลาเอง'
                              ? secondaryColor
                              : primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // กริดสำหรับปุ่มอื่นๆ
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3.5,
                    ),
                    itemCount: times.length -
                        1, // ลดจำนวนปุ่มในกริดลง 1 (ไม่รวม "กำหนดเวลาเอง")
                    itemBuilder: (context, index) {
                      final timeKey = times[index]['key'];
                      final timeValue = times[index]['value'];
                      final isSelected = timeValue == selectedTime;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTime = timeValue;
                          });
                          widget.onSelected(timeValue!);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : secondaryColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Colors.grey : secondaryColor,
                              width: isSelected ? 3 : 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            timeValue!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? secondaryColor : primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
