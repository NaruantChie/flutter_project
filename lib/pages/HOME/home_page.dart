import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:life_countdown/pages/PROVIDERS/locale_provider.dart';
import 'package:life_countdown/pages/PROVIDERS/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ui.Image? backgroundImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final ByteData data =
        await rootBundle.load('assets/images/hourglass-7704147_1280.png');
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frame = await codec.getNextFrame();
    setState(() {
      backgroundImage = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final localeNotifier = Provider.of<LocaleNotifier>(context);

    // ตรวจสอบว่าเป็นโหมดมืดหรือไม่
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(400), // ขนาด AppBar
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Stack(
            children: [
              if (backgroundImage != null)
                CustomPaint(
                  size: const Size(double.infinity, 450),
                  painter: WavePainter(backgroundImage!),
                ),
              Positioned(
                top: 50, // จัดให้อยู่ด้านบน
                left: 16, // ระยะห่างจากซ้าย
                right: 16, // ระยะห่างจากขวา
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<Locale>(
                      value: localeNotifier.locale,
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          localeNotifier.updateLocale(newLocale);
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: const Locale('en'),
                          child: Text(
                            AppLocalizations.of(context)!
                                .languageEnglish, // ใช้ข้อความ Localization
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: const Locale('th'),
                          child: Text(
                            AppLocalizations.of(context)!
                                .languageThai, // ใช้ข้อความ Localization
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],

                      dropdownColor: Colors.grey.shade800, // พื้นหลังเมนู
                      underline: const SizedBox(), // ลบเส้นขีดด้านล่าง
                    ),
                    CustomThemeSwitch(
                      isDarkMode: themeNotifier.themeMode == ThemeMode.dark,
                      onChanged: (bool isDarkMode) {
                        final newMode =
                            isDarkMode ? ThemeMode.dark : ThemeMode.light;
                        themeNotifier.updateThemeMode(newMode);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16), // เพิ่ม Padding ซ้ายและขวา
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ชิดซ้ายสำหรับข้อความ
          mainAxisAlignment:
              MainAxisAlignment.start, // จัดเรียงแนวตั้งจากด้านบน
          children: [
            const SizedBox(height: 16), // เพิ่มระยะห่างด้านบน

            // ใช้ข้อความ Localization
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 16), // ระยะห่างระหว่างข้อความ

            Text(
              AppLocalizations.of(context)!.description,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 25), // ระยะห่างระหว่างข้อความ
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 250, // ความกว้างของปุ่ม
                height: 60, // ความสูงของปุ่ม
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black // สีข้อความเมื่อโหมดมืด
                            : Colors.white, // สีข้อความเมื่อโหมดสว่าง
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white // สีปุ่มเมื่อโหมดมืด
                            : Colors.black, // สีปุ่มเมื่อโหมดสว่าง
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18), // ความโค้งของปุ่ม
                    ),
                  ),
                  onPressed: () {
                    context.go('/about'); // การทำงานเมื่อกดปุ่ม
                  },
                  child: Text(
                    AppLocalizations.of(context)!.startButton,
                    style: const TextStyle(
                      fontSize: 24, // ขนาดตัวหนังสือ
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20), // ระยะห่างระหว่างปุ่ม

            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // จัดปุ่มให้อยู่ตรงกลางในแนวนอน
                children: [
                  SizedBox(
                    width: 150, // ความกว้างของปุ่ม
                    height: 50, // ความสูงของปุ่ม
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black // สีข้อความเมื่อโหมดมืด
                                : Colors.white, // สีข้อความเมื่อโหมดสว่าง
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white // สีปุ่มเมื่อโหมดมืด
                                : Colors.black, // สีปุ่มเมื่อโหมดสว่าง
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // ความโค้งของขอบปุ่ม
                        ),
                      ),
                      onPressed: () {
                        // การกระทำเมื่อกดปุ่ม "เกี่ยวกับเรา"
                      },
                      child: Text(
                        AppLocalizations.of(context)!.aboutUsButton,
                        style: const TextStyle(fontSize: 18), // ขนาดตัวอักษร
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // ระยะห่างระหว่างปุ่ม
                  SizedBox(
                    width: 150, // ความกว้างของปุ่ม
                    height: 50, // ความสูงของปุ่ม
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : Colors.white,
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // ความโค้งของขอบปุ่ม
                        ),
                      ),
                      onPressed: () {
                        // การกระทำเมื่อกดปุ่ม "สนับสนุน"
                      },
                      child: Text(
                        AppLocalizations.of(context)!.supportButton,
                        style: const TextStyle(fontSize: 18), // ขนาดตัวอักษร
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomThemeSwitch extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const CustomThemeSwitch({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isDarkMode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 60,
        height: 30,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.wb_sunny,
                color: isDarkMode ? Colors.grey : Colors.yellow,
                size: 20,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.nightlight_round,
                color: isDarkMode ? Colors.blue : Colors.grey,
                size: 20,
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment:
                  isDarkMode ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final ui.Image backgroundImage;

  WavePainter(this.backgroundImage);

  @override
  void paint(Canvas canvas, Size size) {
    // วาดเงา
    final shadowPaint = Paint()
      // ignore: deprecated_member_use
      ..color = Colors.black.withOpacity(1) // สีเงาพร้อมความโปร่งใส
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10); // ความฟุ้ง

    final Path shadowPath = Path();
    shadowPath.lineTo(0, size.height * 0.7);
    shadowPath.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.9);
    shadowPath.quadraticBezierTo(
        size.width * 0.75, size.height * 0.8, size.width, size.height);
    shadowPath.lineTo(size.width, 0);
    shadowPath.close();

    canvas.drawPath(shadowPath, shadowPaint); // วาดเงาก่อน

    // วาดพื้นหลังด้วยรูปภาพ
    final imagePaint = Paint()
      ..shader = ImageShader(
        backgroundImage,
        TileMode.clamp,
        TileMode.clamp,
        Matrix4.identity()
            .scaled(
              size.width / backgroundImage.width,
              size.height / backgroundImage.height,
            )
            .storage,
      )
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.9);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.8, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, imagePaint); // วาดรูปร่างคลื่นด้วยภาพ
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor, // สีข้อความ
      ),
      onPressed: onPressed, // ฟังก์ชันเมื่อกดปุ่ม
      child: Text(label), // ข้อความในปุ่ม
    );
  }
}
