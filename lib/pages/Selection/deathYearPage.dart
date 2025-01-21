import 'package:flutter/material.dart';

class DeathYearPage extends StatefulWidget {
  final Function(int) onSelected;
  final int birthYear; // รับค่า birthYear

  const DeathYearPage({
    Key? key,
    required this.onSelected,
    required this.birthYear, // ใช้ค่าที่ส่งมา
  }) : super(key: key);

  @override
  State<DeathYearPage> createState() => _DeathYearPageState();
}

class _DeathYearPageState extends State<DeathYearPage> {
  int? selectedYear;

  @override
  Widget build(BuildContext context) {
    // ปีพุทธศักราชปัจจุบัน
    final currentYear = DateTime.now().year + 543;

    // ใช้ birthYear ที่ส่งมาจากหน้า Description
    final birthYear = widget.birthYear;

    // สร้างรายการปีและคำนวณอายุในปีนั้น
    final years = List.generate(70, (index) {
      final year = currentYear + index; // เพิ่มปีจากปีปัจจุบัน
      final ageInThatYear = year - birthYear; // คำนวณอายุในปีนั้น
      return {'year': year, 'ageInThatYear': ageInThatYear};
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // จัดข้อความชิดซ้าย
            children: [
              Text(
                "ปีตาย",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white // ใช้สีขาวในโหมดมืด
                      : Colors.black, // ใช้สีดำในโหมดสว่าง
                ),
              ),
              const SizedBox(height: 8), // เพิ่มระยะห่างระหว่างข้อความ
              Text(
                "คุณคิดว่าคุณจะตายปีใด?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white // ใช้สีขาวในโหมดมืด
                      : Colors.black, // ใช้สีดำในโหมดสว่าง
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: years.length,
            itemBuilder: (context, index) {
              final item = years[index];
              final isSelected = item['year'] == selectedYear;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedYear = item['year'];
                  });
                  widget.onSelected(selectedYear!);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? (Theme.of(context).brightness == Brightness.light
                              ? Colors.black // พื้นหลังเมื่อเลือกในโหมดสว่าง
                              : Colors.white) // พื้นหลังเมื่อเลือกในโหมดมืด
                          : (Theme.of(context).brightness == Brightness.light
                              ? Colors
                                  .white // พื้นหลังเมื่อยังไม่ได้เลือกในโหมดสว่าง
                              : Colors
                                  .black), // พื้นหลังเมื่อยังไม่ได้เลือกในโหมดมืด
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors
                                      .white // กรอบสีขาวเมื่อพื้นหลังเป็นสีดำ
                                  : Colors
                                      .black, // กรอบสีดำเมื่อพื้นหลังเป็นสีขาว
                              width: 2,
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'พ.ศ. ${item['year']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? (Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors
                                        .white // สีข้อความเมื่อเลือกในโหมดสว่าง
                                    : Colors
                                        .black) // สีข้อความเมื่อเลือกในโหมดมืด
                                : (Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors
                                        .black // สีข้อความเมื่อยังไม่ได้เลือกในโหมดสว่าง
                                    : Colors
                                        .white), // สีข้อความเมื่อยังไม่ได้เลือกในโหมดมืด
                          ),
                        ),
                        Text(
                          'อายุ ${item['ageInThatYear']} ปี',
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected
                                ? (Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors
                                        .white // สีข้อความเมื่อเลือกในโหมดสว่าง
                                    : Colors
                                        .black) // สีข้อความเมื่อเลือกในโหมดมืด
                                : (Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors
                                        .black // สีข้อความเมื่อยังไม่ได้เลือกในโหมดสว่าง
                                    : Colors
                                        .white), // สีข้อความเมื่อยังไม่ได้เลือกในโหมดมืด
                          ),
                        ),
                      ],
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
