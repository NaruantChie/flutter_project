import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'dart:math' as math; // เพิ่มการ import

class LifeCountdownPage extends StatefulWidget {
  final DateTime deathDate;
  final DateTime birthDate;

  const LifeCountdownPage({
    Key? key,
    required this.deathDate,
    required this.birthDate,
  }) : super(key: key);

  @override
  _LifeCountdownPageState createState() => _LifeCountdownPageState();
}

class _LifeCountdownPageState extends State<LifeCountdownPage> {
  late Timer _timer;
  late Duration _timeRemaining;
  late Duration _totalLifeSpan;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.deathDate.difference(DateTime.now());
    _totalLifeSpan = widget.deathDate.difference(widget.birthDate);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining = widget.deathDate.difference(DateTime.now());
        if (_timeRemaining.isNegative) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatYearsAndDays(Duration duration) {
    final years = duration.inDays ~/ 365;
    final days = duration.inDays % 365;
    return "$years ปี $days วัน";
  }

  String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return "$days วัน $hours ชั่วโมง $minutes นาที $seconds วินาที";
  }

  @override
  Widget build(BuildContext context) {
    final elapsedLifeSpan = _totalLifeSpan - _timeRemaining;
    final double percentagePassed =
        ((_totalLifeSpan.inSeconds - _timeRemaining.inSeconds) /
                _totalLifeSpan.inSeconds *
                100)
            .clamp(0, 100)
            .toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Life Countdown",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "คุณเหลือเวลาอีก",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatDuration(_timeRemaining),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: PageView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      height: 250,
                      width: 350,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // CustomPaint สำหรับวงกลม
                          Positioned(
                            child: CustomPaint(
                              painter: HalfCircleProgressPainter(
                                percentage: percentagePassed,
                              ),
                            ),
                            width: 250,
                            height: 250,
                          ),
                          // ข้อความเปอร์เซ็นต์ตรงกลาง
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "ผ่านไปแล้ว",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${percentagePassed.toStringAsFixed(1)}%",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          // ไอคอนด้านล่าง
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Column(
                              children: [
                                Icon(Icons.child_friendly,
                                    color: Colors.orange, size: 48),
                                const Text("เกิด",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: Column(
                              children: [
                                Icon(Icons.person,
                                    color: Colors.orange, size: 48),
                                const Text("ตาย",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "กราฟแสดงเวลา",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 150,
                      width: 150,
                      color: Colors.orange[100],
                      child: const Center(
                        child: Icon(
                          Icons.bar_chart,
                          size: 64,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "เทียนแสดงเวลา",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 150,
                      width: 150,
                      color: Colors.blueGrey[900],
                      child: const Center(
                        child: Icon(
                          Icons.candlestick_chart,
                          size: 64,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text("แชร์"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text("เริ่มใหม่"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HalfCircleProgressPainter extends CustomPainter {
  final double percentage;

  HalfCircleProgressPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    // ฟังก์ชันสำหรับสร้าง Paint
    Paint createPaint(Color color, PaintingStyle style, double strokeWidth,
        {StrokeCap? strokeCap}) {
      return Paint()
        ..color = color
        ..style = style
        ..strokeWidth = strokeWidth
        ..strokeCap =
            strokeCap ?? StrokeCap.butt; // ค่าเริ่มต้นเป็น StrokeCap.butt
    }

    // สร้าง Paint สำหรับ background, overlay, และ progress
    final Paint backgroundPaint =
        createPaint(Colors.grey[300]!, PaintingStyle.stroke, 60);
    final Paint overlayPaint =
        createPaint(Colors.blue, PaintingStyle.stroke, 70); // อีกชั้นหนึ่งสีฟ้า
    final Paint progressPaint =
        createPaint(Colors.orange, PaintingStyle.stroke, 60);

    // สร้าง Paint สำหรับ needle และ line
    final Paint needlePaint = createPaint(
        Colors.red, PaintingStyle.fill, 0); // ไม่ต้องการ strokeWidth
    final Paint linePaint = createPaint(Colors.red, PaintingStyle.stroke, 4);

    // คำนวณค่าที่จำเป็น
    final double startAngle = -math.pi; // เริ่มจาก -180 องศา
    final double radius = size.width / 2; // รัศมีของครึ่งวงกลม
    final double needleRadiusFactor = 1.36; // ระยะที่เข็มอยู่ด้านนอก
    final double lineLengthFactor = 0.76; // ความยาวของเส้นเข็มลดลง

    // จุดศูนย์กลางของวงกลม
    final Offset center = Offset(size.width / 2, size.height / 2);

    // คำนวณมุม sweepAngle
    final double needlePaddingAngle =
        (10 / (radius * needleRadiusFactor)); // มุมระยะเผื่อ
    final double sweepAngle = math.pi * (percentage / 100) - needlePaddingAngle;

    // คำนวณมุมและตำแหน่งเข็ม
    final double needleAngle = startAngle + math.pi * (percentage / 104);

    // ตำแหน่งปลายเข็ม
    final Offset needlePosition = Offset(
      center.dx + (radius * needleRadiusFactor) * math.cos(needleAngle),
      center.dy + (radius * needleRadiusFactor) * math.sin(needleAngle),
    );

    // ตำแหน่งเริ่มต้นของเส้นเข็ม (ลดจากจุดศูนย์กลาง)
    final Offset startPoint = Offset(
      center.dx + (radius * lineLengthFactor) * math.cos(needleAngle),
      center.dy + (radius * lineLengthFactor) * math.sin(needleAngle),
    );

    // วาดพื้นหลังของวงกลม
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, startAngle, math.pi, false, backgroundPaint);

    // วาดชั้น overlay
    canvas.drawArc(rect, startAngle, math.pi, false, overlayPaint);

    // วาด progress
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

    // วาดเส้นเข็ม
    canvas.drawLine(startPoint, needlePosition, linePaint);

    // วาดวงกลมที่ปลายเข็ม
    canvas.drawCircle(needlePosition, 15, needlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
