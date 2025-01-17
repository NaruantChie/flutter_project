import 'package:flutter/material.dart';

class DeathYearPage extends StatelessWidget {
  const DeathYearPage({super.key});

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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            "คุณคิดว่าคุณจะตายปีใด?",
            style: TextStyle(fontSize: 16, color: Colors.orange),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: years.length,
            itemBuilder: (context, index) {
              final item = years[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange[50],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'พ.ศ. ${item['year']}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'อายุ ${item['age']} ปี',
                        style: const TextStyle(fontSize: 16, color: Colors.orange),
                      ),
                    ],
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
