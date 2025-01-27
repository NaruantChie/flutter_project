import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.grey[900]
            : const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          AppLocalizations.of(context)!.back,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปยังหน้าก่อนหน้าใน stack
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "สนับสนุน",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "สนับสนุน Peaceful Death\n"
              "ท่านสามารถร่วมสมทบทุนการจัดทำสื่อและกิจกรรมการเรียนรู้ เรื่องการอยู่และตายดีของ Peaceful Death ด้วยการโอนเงินที่บัญชี",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Image.asset(
                  'assets/images/logo.png', // ไฟล์โลโก้ธนาคาร
                  width: 24, // กำหนดขนาดโลโก้
                  height: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  "ธนาคารกสิกรไทย สาขา บางขุน",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "เลขที่บัญชี 156-8-02777-5",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "ชื่อบัญชี น.ส.วรรณา จารุสมบูรณ์ และ น.ส.ฐณิตา อภินะกุลชัย และ น.ส.ปิญชิตา ผ่องพุฒคุณ",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // ย้อนกลับไปยังหน้าก่อนหน้าใน stack
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color.fromARGB(255, 251, 251, 251)
                      : const Color.fromARGB(255, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 130,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
