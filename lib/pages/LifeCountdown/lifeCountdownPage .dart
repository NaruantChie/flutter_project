import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              fontSize: 24,
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
                    SizedBox(
                      height: 250,
                      width: 350,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // CustomPaint สำหรับวงกลม
                          Positioned(
                            width: 250,
                            height: 250,
                            child: CustomPaint(
                              painter: HalfCircleProgressPainter(
                                percentage: percentagePassed,
                              ),
                            ),
                          ),
                          // ข้อความเปอร์เซ็นต์ตรงกลาง
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              const Text(
                                "ผ่านไปแล้ว",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${percentagePassed.toStringAsFixed(1)}%",
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          // ไอคอนด้านล่างซ้าย
                          // ไอคอนด้านล่างซ้าย
                          // ไอคอนด้านล่างซ้าย
                          Positioned(
                            bottom: 0,
                            left: 19,
                            child: Column(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Colors.orange
                                        .withOpacity(0.3), // สีพื้นหลัง
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(
                                          32), // โค้งเฉพาะด้านล่าง
                                    ),
                                  ),
                                  child: Icon(FontAwesomeIcons.baby,
                                      color:
                                          const Color.fromARGB(255, 75, 75, 75),
                                      size: 32),
                                ),
                                const SizedBox(height: 4),
                                const Text("เกิด",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
// ไอคอนด้านล่างขวา
                          Positioned(
                            bottom: 0,
                            right: 19,
                            child: Column(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Colors.grey
                                        .withOpacity(0.3), // สีพื้นหลัง
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(
                                          32), // โค้งเฉพาะด้านล่าง
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // กรอบรอบไอคอน
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .transparent, // พื้นหลังโปร่งใส
                                          border: Border.all(
                                            color: Colors.grey, // สีของกรอบ
                                            width: 2, // ความหนาของกรอบ
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              8), // โค้งเล็กน้อย
                                        ),
                                      ),
                                      // ไอคอนรูปคน
                                      Icon(
                                        Icons.person,
                                        color: const Color.fromARGB(
                                            255, 75, 75, 75),
                                        size: 32,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "ตาย",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        YearGrid(
                          startYear:
                              widget.birthDate.year, // ปีเกิด (ปีเริ่มต้น)
                          endYear: widget.deathDate.year, // ปีตาย (ปีสุดท้าย)
                          currentYear: DateTime.now().year, // ปีปัจจุบัน
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    CandleWidget(
                      remainingPercentage: (_timeRemaining.inSeconds /
                              _totalLifeSpan.inSeconds) *
                          100,
                    )
// ใส่ค่าตัวเลขเป็นเปอร์เซ็นต์
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
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
////////////////////////////////////////////////////////////////////////////////////////

class HalfCircleProgressPainter extends CustomPainter {
  final double percentage;
  final double startLineOffset; // ระยะขยับของเส้นเริ่มต้น
  final double endLineOffset; // ระยะขยับของเส้นสุดท้าย
  final double startLineLengthInner; // ความยาวเส้นด้านในของจุดเริ่มต้น
  final double startLineLengthOuter; // ความยาวเส้นด้านนอกของจุดเริ่มต้น
  final double endLineLengthInner; // ความยาวเส้นด้านในของจุดสุดท้าย
  final double endLineLengthOuter; // ความยาวเส้นด้านนอกของจุดสุดท้าย

  HalfCircleProgressPainter({
    required this.percentage,
    this.startLineOffset = 1.9,
    this.endLineOffset = 1.9,
    this.startLineLengthInner = 33.4, //ปรับความยาวเส้นเริ่มต้น
    this.startLineLengthOuter = 53,
    this.endLineLengthInner = 32.2, //ปรับความยาวเส้นท้ายสุด
    this.endLineLengthOuter = 53,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double yOffset = 35; // ระยะเลื่อนลงในแกน Y

    Paint createPaint(Color color, PaintingStyle style, double strokeWidth,
        {StrokeCap? strokeCap}) {
      return Paint()
        ..color = color
        ..style = style
        ..strokeWidth = strokeWidth
        ..strokeCap = strokeCap ?? StrokeCap.butt;
    }

    // สร้าง Paint สำหรับ background, progress และ border
    final Paint backgroundPaint =
        createPaint(Colors.grey[300]!, PaintingStyle.stroke, 60);
    final Paint progressPaint =
        createPaint(Colors.orange, PaintingStyle.stroke, 60);
    final Paint borderPaint = createPaint(const Color.fromARGB(255, 0, 0, 0),
        PaintingStyle.stroke, 3); // ขอบเส้นประ
    final Paint innerBorderPaint = createPaint(
        const Color.fromARGB(255, 0, 0, 0),
        PaintingStyle.stroke,
        3); // ขอบเส้นเต็มด้านใน

    final Paint needlePaint = createPaint(const Color.fromARGB(255, 0, 0, 0),
        PaintingStyle.fill, 0); // ไม่ต้องการ strokeWidth
    final Paint linePaint = createPaint(
        const Color.fromARGB(255, 0, 0, 0), PaintingStyle.stroke, 3);
    final Paint startEndLinePaint = createPaint(
        const Color.fromARGB(255, 0, 0, 0),

        ///
        PaintingStyle.stroke,
        3); // เส้นตรงที่จุดเริ่มต้นและจุดสุดท้าย

    // คำนวณค่าที่จำเป็น
    final double startAngle = -math.pi; // เริ่มจาก -180 องศา
    final double radius = size.width / 2; // รัศมีของครึ่งวงกลม
    final double needleRadiusFactor = 1.36; // ระยะที่เข็มอยู่ด้านนอก
    final double lineLengthFactor = 0.76; // ความยาวของเส้นเข็มลดลง

    // จุดศูนย์กลางของวงกลม
    final Offset center = Offset(size.width / 2, size.height / 2 + yOffset);

    // คำนวณมุม sweepAngle
    final double needlePaddingAngle =
        (0 / (radius * needleRadiusFactor)); // มุมระยะเผื่อ
    final double sweepAngle = math.pi * (percentage / 100) - needlePaddingAngle;

    // คำนวณมุมและตำแหน่งเข็ม
    final double needleAngle = startAngle + math.pi * (percentage / 100);

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
    final Rect rect = Rect.fromLTWH(0, yOffset, size.width, size.height);
    canvas.drawArc(rect, startAngle, math.pi, false, backgroundPaint);

    // ปรับ rect สำหรับขอบสีแดงให้อยู่ด้านนอก
    final Rect borderRect = Rect.fromLTWH(
      -45, // เพิ่มขอบให้อยู่ด้านนอก
      -45 + yOffset,
      size.width + 90,
      size.height + 97,
    );

    // สร้างเส้นประสำหรับ borderPaint
    final Path borderPath = Path();
    const double dashWidth = 12; // ความยาวของเส้น
    const double dashSpace = 6; // ความกว้างของช่องว่าง

    for (double i = 0; i < math.pi * radius * 2; i += dashWidth + dashSpace) {
      final double startAngleDash = startAngle + (i / radius);
      final double endAngleDash = startAngle + ((i + dashWidth) / radius);

      // ตรวจสอบมุมเพื่อไม่ให้เกินครึ่งวงกลม
      if (endAngleDash > startAngle + math.pi) {
        break;
      }

      borderPath.addArc(
        borderRect,
        startAngleDash,
        endAngleDash - startAngleDash,
      );
    }

    // วาด border เส้นประ
    canvas.drawPath(borderPath, borderPaint);

    // วาดขอบเส้นเต็มด้านใน
    final Rect innerBorderRect = Rect.fromLTWH(
      32, // ลดขนาดให้อยู่ด้านใน
      32 + yOffset,
      size.width - 63,
      size.height - 63,
    );
    canvas.drawArc(
        innerBorderRect, startAngle, math.pi, false, innerBorderPaint);

    // วาดเส้นตรงที่จุดเริ่มต้น
    final Offset startLineStart = Offset(
      center.dx + (radius - startLineLengthInner) * math.cos(startAngle),
      center.dy +
          (radius - startLineLengthInner) * math.sin(startAngle) +
          startLineOffset,
    );
    final Offset startLineEnd = Offset(
      center.dx + (radius + startLineLengthOuter) * math.cos(startAngle),
      center.dy +
          (radius + startLineLengthOuter) * math.sin(startAngle) +
          startLineOffset,
    );
    canvas.drawLine(startLineStart, startLineEnd, startEndLinePaint);

    // วาดเส้นตรงที่จุดสุดท้าย
    final double endAngle = startAngle + math.pi;
    final Offset endLineStart = Offset(
      center.dx + (radius - endLineLengthInner) * math.cos(endAngle),
      center.dy +
          (radius - endLineLengthInner) * math.sin(endAngle) +
          endLineOffset,
    );
    final Offset endLineEnd = Offset(
      center.dx + (radius + endLineLengthOuter) * math.cos(endAngle),
      center.dy +
          (radius + endLineLengthOuter) * math.sin(endAngle) +
          endLineOffset,
    );
    canvas.drawLine(endLineStart, endLineEnd, startEndLinePaint);

    // วาด progress
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

    // วาดเส้นเข็ม
    canvas.drawLine(startPoint, needlePosition, linePaint);

    // วาดวงกลมที่ปลายเข็ม (วงกลมนอก)
    canvas.drawCircle(needlePosition, 15, needlePaint);

    // วาดวงกลมด้านในที่ปลายเข็ม (วงกลมใน)
    final Paint innerCirclePaint = createPaint(
        const Color.fromARGB(255, 255, 255, 255)
            .withOpacity(1), // สีของวงกลมแรกด้านใน
        PaintingStyle.fill,
        0); // ไม่ต้องการ strokeWidth
    final double innerCircleRadius1 = 12; // ขนาดของวงกลมแรกด้านใน
    canvas.drawCircle(needlePosition, innerCircleRadius1, innerCirclePaint);

    // วาดวงกลมที่สองด้านใน (เพิ่มวงกลมใหม่)
    final Paint secondInnerCirclePaint = createPaint(
        Colors.orange.withOpacity(1), // สีของวงกลมที่สองด้านใน
        PaintingStyle.fill,
        0); // ไม่ต้องการ strokeWidth
    final double innerCircleRadius2 = 8.5; // ขนาดของวงกลมที่สองด้านใน
    canvas.drawCircle(
        needlePosition, innerCircleRadius2, secondInnerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

////////////////////////////////////////////////////////////////////////////////////////
class YearGrid extends StatelessWidget {
  final int startYear; // ปีเกิด (ปีเริ่มต้น)
  final int endYear; // ปีสุดท้าย
  final int currentYear; // ปีปัจจุบัน

  const YearGrid({
    Key? key,
    required this.startYear,
    required this.endYear,
    required this.currentYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalYears =
        endYear - startYear - 1; // คำนวณจำนวนปีที่นับ (ไม่นับปีเกิดและปีตาย)
    final elapsedYears =
        currentYear - startYear - 1; // ปีที่ผ่านไปแล้ว (ไม่นับปีเกิด)

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Wrap(
            spacing: 8, // ระยะห่างระหว่างคอลัมน์
            runSpacing: 8, // ระยะห่างระหว่างแถว
            children: List.generate(totalYears + 2, (index) {
              // ช่องแรกและช่องสุดท้ายไม่นับปีในช่วง
              final isFirst = index == 0;
              final isLast = index == totalYears + 1;
              final isElapsed = !isFirst &&
                  !isLast &&
                  index - 1 <= elapsedYears; // ตรวจสอบว่าผ่านปีหรือยัง
              final isCurrent = !isFirst &&
                  !isLast &&
                  index - 1 == elapsedYears; // ตรวจสอบว่าคือปีปัจจุบัน
              final isFinalYear =
                  currentYear == endYear; // ตรวจสอบว่าปีสุดท้ายแล้วหรือไม่

              return Container(
                alignment: Alignment.center,
                width:
                    isFirst || isLast ? 87 : 40, // ขนาดความกว้างที่แตกต่างกัน
                height: 35, // ความสูงของทุกช่อง
                decoration: BoxDecoration(
                  color: isFirst
                      ? Colors.orange // สีช่องแรก "เกิด"
                      : isLast
                          ? (isFinalYear
                              ? Color.fromRGBO(
                                  46, 82, 156, 0.5) // สีพิเศษสำหรับปีสุดท้าย
                              : const Color.fromRGBO(
                                  46, 82, 156, 1.0)) // สีช่องสุดท้าย "ตาย"
                          : isCurrent
                              ? const Color.fromRGBO(
                                  46, 82, 156, 1.0) // สีปีปัจจุบัน
                              : isElapsed
                                  ? Colors.orange
                                  : Colors.grey[300], // สีของช่อง
                  borderRadius: BorderRadius.circular(4), // ความโค้งมุม
                  boxShadow: isCurrent || isFinalYear
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5), // เงาสีดำ
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: isFirst
                    ? Text(
                        "เกิด",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : isLast
                        ? (isFinalYear
                            ? Icon(
                                Icons.radio_button_on, // ไอคอนสำหรับปีสุดท้าย
                                color: Colors.orange,
                              )
                            : Text(
                                "ตาย",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        : isCurrent
                            ? Icon(
                                Icons
                                    .arrow_circle_right_outlined, // ไอคอนสำหรับปีปัจจุบัน
                                color: Colors.orange,
                              )
                            : Container(), // ช่องอื่นไม่แสดงข้อความ
              );
            }),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////

class CandlePainter extends CustomPainter {
  final double remainingPercentage;
  final double flameScale;
  final double innerFlameScale;
  final double smallestFlameScale;

  CandlePainter(
    this.remainingPercentage, {
    required this.flameScale,
    required this.innerFlameScale,
    required this.smallestFlameScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.orange;

    // ฐานเทียน
    final baseRect = Rect.fromLTWH(0, size.height - 20, size.width, 20);
    canvas.drawRect(baseRect, paint);

    // ความสูงของเทียน
    final candleHeight = size.height * 0.5 * (remainingPercentage / 100);

    // วาดตัวเทียนก่อน (เพื่อให้อยู่ด้านหลังเปลวไฟ)
    final candleBodyPaint = Paint()..color = Colors.orangeAccent;
    final candleBody = Rect.fromLTWH(
      size.width * 0.4,
      size.height * 0.3 + (size.height * 0.5 - candleHeight),
      size.width * 0.2,
      candleHeight,
    );
    canvas.drawRect(candleBody, candleBodyPaint);
////////////////////////////////////////////////////////////////////////////
// วาดขี้เทียนที่ละลาย/*
    /* final meltedPaint = Paint()
      ..color = const Color.fromARGB(255, 245, 208, 152).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final meltedPath = Path();
    meltedPath.moveTo(
        size.width * 0.6,
        size.height * 0.3 +
            (size.height * 0.5 - candleHeight)); // จุดเริ่มต้นบนเทียน
    meltedPath.cubicTo(
      size.width * 0.7,
      size.height * 0.1 + (size.height * 0.5 - candleHeight) + 80, // โค้งซ้ายลง
      size.width * 0.45,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) +
          30, // จุดต่ำสุดซ้าย
      size.width * 0.38,
      size.height * 0.3 +
          (size.height * 0.4 - candleHeight) +
          60, // โค้งกลับขึ้น
    );
    meltedPath.cubicTo(
      size.width * 0.1,
      size.height * 0.1 + (size.height * 0.5 - candleHeight) + 15, // โค้งขวาลง
      size.width * 0.35,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) +
          20, // จุดต่ำสุดขวา
      size.width * 0.8,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight), // กลับไปจุดเริ่มต้น
    );

    canvas.drawPath(meltedPath, meltedPaint);

    canvas.drawPath(meltedPath, meltedPaint);*/
////////////////////////////////////////////////////////////////////////////
    // วาดไส้เทียน (ให้อยู่ด้านหลังเปลวไฟ)
    final wickPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0;
    final wickOffset = Offset(
      size.width * 0.5,
      size.height * 0.3 + (size.height * 0.5 - candleHeight) - 20,
    );
    canvas.drawLine(
      wickOffset,
      Offset(
        size.width * 0.5,
        size.height * 0.3 + (size.height * 0.5 - candleHeight),
      ),
      wickPaint,
    );

    // เปลวไฟใหญ่
    // วาดแสงรอบเปลวไฟ
    final lightRadius = 100 * flameScale; // ขนาดรัศมีของแสงรอบเปลวไฟ
    final lightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.orange.withOpacity(0.5), // สีใกล้เปลวไฟ
          Colors.yellow.withOpacity(0.2), // สีไกลออกไป
          Colors.transparent, // ขอบเขตนอกสุดของแสง
        ],
        stops: [0.0, 0.6, 1.0], // ตำแหน่งการเปลี่ยนสี
      ).createShader(Rect.fromCircle(
        center: Offset(
          wickOffset.dx, // ตำแหน่ง X ไม่เปลี่ยน
          wickOffset.dy - 30, // ขยับขึ้นในแกน Y (เพิ่มค่าลบ)
        ),
        radius: lightRadius,
      ));

    // วาดวงกลมแสงรอบเปลวไฟ
    canvas.drawCircle(
      Offset(
        wickOffset.dx, // ตำแหน่ง X
        wickOffset.dy - 30, // ตำแหน่ง Y ขยับขึ้น
      ),
      lightRadius,
      lightPaint,
    );

    /////////////////////////////////////////////////////
    final flamePath = Path();
    const flameOffset = 20.0; // เลื่อนเปลวไฟใหญ่ลง
    flamePath.moveTo(
      size.width * 0.5,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          120 * flameScale +
          flameOffset,
    );
    flamePath.quadraticBezierTo(
      size.width * 0.5 - 50 * flameScale,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          40 * flameScale +
          flameOffset,
      size.width * 0.5,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          40 * flameScale +
          flameOffset,
    );
    flamePath.quadraticBezierTo(
      size.width * 0.5 + 50 * flameScale,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          40 * flameScale +
          flameOffset,
      size.width * 0.5,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          120 * flameScale +
          flameOffset,
    );

    final flamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Colors.orange, Colors.yellow, Colors.white],
      ).createShader(Rect.fromCircle(
        center: Offset(
            size.width * 0.5,
            size.height * 0.3 +
                (size.height * 0.5 - candleHeight) -
                60 +
                flameOffset),
        radius: 50,
      ));

    canvas.drawPath(flamePath, flamePaint);

    // เปลวไฟด้านใน
    final innerFlamePath = Path();
    innerFlamePath.moveTo(
      size.width * 0.5,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          80 * innerFlameScale,
    );
    innerFlamePath.quadraticBezierTo(
      size.width * 0.5 - 35 * innerFlameScale,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          20 * innerFlameScale,
      size.width * 0.5,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          20 * innerFlameScale,
    );
    innerFlamePath.quadraticBezierTo(
      size.width * 0.5 + 35 * innerFlameScale,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          20 * innerFlameScale,
      size.width * 0.5,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          80 * innerFlameScale,
    );

    final innerFlamePaint = Paint()..color = Color.fromRGBO(255, 209, 155, 1.0);
    canvas.drawPath(innerFlamePath, innerFlamePaint);

    // เปลวไฟลูกที่สาม (เล็กที่สุด)
    final smallestFlamePath = Path();
    smallestFlamePath.moveTo(
      size.width * 0.5,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          60 * smallestFlameScale,
    );
    smallestFlamePath.quadraticBezierTo(
      size.width * 0.5 - 22 * smallestFlameScale,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          30 * smallestFlameScale,
      size.width * 0.5,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          20 * smallestFlameScale,
    );
    smallestFlamePath.quadraticBezierTo(
      size.width * 0.5 + 22 * smallestFlameScale,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          30 * smallestFlameScale,
      size.width * 0.5,
      size.height * 0.3 +
          (size.height * 0.5 - candleHeight) -
          60 * smallestFlameScale,
    );

    final smallestFlamePaint = Paint()..color = Colors.white;
    canvas.drawPath(smallestFlamePath, smallestFlamePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CandleWidget extends StatefulWidget {
  final double remainingPercentage;

  const CandleWidget({Key? key, required this.remainingPercentage})
      : super(key: key);

  @override
  _CandleWidgetState createState() => _CandleWidgetState();
}

class _CandleWidgetState extends State<CandleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flameAnimation;
  late Animation<double> _innerFlameAnimation;
  late Animation<double> _smallestFlameAnimation;

  @override
  void initState() {
    super.initState();

    // สร้าง AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // ระยะเวลาการเคลื่อนไหว
    )..repeat(reverse: true);

    // สร้าง Animation ต่าง ๆ สำหรับเปลวไฟ
    _flameAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _innerFlameAnimation = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _smallestFlameAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // ลบ controller เมื่อเลิกใช้งาน
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(280, 300), // ขนาดของเทียน
          painter: CandlePainter(
            widget.remainingPercentage, // เปอร์เซ็นต์ของเทียนที่เหลือ
            flameScale: _flameAnimation.value, // ขนาดของเปลวไฟใหญ่
            innerFlameScale: _innerFlameAnimation.value, // ขนาดของเปลวไฟด้านใน
            smallestFlameScale:
                _smallestFlameAnimation.value, // ขนาดของเปลวไฟเล็กสุด
          ),
        );
      },
    );
  }
}
