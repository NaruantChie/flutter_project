import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  int topSheetIndex = 3; // กำหนดแผ่นที่ 4 อยู่บนสุดเริ่มต้น

  final List<Map<String, dynamic>> sheets = [
    {
      'title': 'แผ่นที่ 1',
      'color': Colors.green[400],
      'maxChildSize': 0.9,
      'initialChildSize': 0.9,
      'minChildSize': 0.3,
    },
    {
      'title': 'แผ่นที่ 2',
      'color': Colors.blue[400],
      'maxChildSize': 0.8,
      'initialChildSize': 0.8,
      'minChildSize': 0.3,
    },
    {
      'title': 'แผ่นที่ 3',
      'color': Colors.orange[400],
      'maxChildSize': 0.7,
      'initialChildSize': 0.7,
      'minChildSize': 0.3,
    },
    {
      'title': 'แผ่นที่ 4',
      'color': Colors.purple[400],
      'maxChildSize': 0.6,
      'initialChildSize': 0.6,
      'minChildSize': 0.3,
    },
  ];

  void bringNextSheetToFront() {
    setState(() {
      topSheetIndex = (topSheetIndex - 1 + sheets.length) % sheets.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("กลับ"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/description');
          },
        ),
      ),
      body: Stack(
        children: [
          // ด้านล่างสุด (Background)
          Container(
            color: isDarkMode ? Colors.black : Colors.white,
          ),
          // ใช้ AnimatedSwitcher สำหรับเปลี่ยนแผ่นอย่างสมูท
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: DraggableScrollableSheet(
              key: ValueKey<int>(topSheetIndex),
              initialChildSize: sheets[topSheetIndex]['initialChildSize'],
              minChildSize: sheets[topSheetIndex]['minChildSize'],
              maxChildSize: sheets[topSheetIndex]['maxChildSize'],
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: sheets[topSheetIndex]['color'],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      sheets[topSheetIndex]['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ปุ่มสลับแผ่นที่ตำแหน่งคงที่
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: bringNextSheetToFront,
                child: const Text("สลับแผ่น"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
