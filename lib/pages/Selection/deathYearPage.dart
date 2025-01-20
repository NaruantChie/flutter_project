import 'package:flutter/material.dart';

class DeathYearPage extends StatefulWidget {
  final Function(int) onSelected; // เพิ่มพารามิเตอร์ onSelected

  const DeathYearPage({super.key, required this.onSelected});

  @override
  State<DeathYearPage> createState() => _DeathYearPageState();
}

class _DeathYearPageState extends State<DeathYearPage> {
  int? selectedYear;

  @override
  Widget build(BuildContext context) {
    final years = List.generate(15, (index) {
      final year = 2568 + index;
      final age = index + 2;
      return {'year': year, 'age': age};
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "ปีตาย",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  widget.onSelected(selectedYear!); // เรียก callback
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? Colors.orange[100]
                          : Colors.orange[50],
                      border: isSelected
                          ? Border.all(color: Colors.orange, width: 2)
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'พ.ศ. ${item['year']}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'อายุ ${item['age']} ปี',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.orange),
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
