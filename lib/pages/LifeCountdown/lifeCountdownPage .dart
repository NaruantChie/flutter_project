import 'package:flutter/material.dart';
import 'dart:async';

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
    final percentagePassed =
        ((_totalLifeSpan.inSeconds - _timeRemaining.inSeconds) /
                _totalLifeSpan.inSeconds *
                100)
            .clamp(0, 100);

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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "คุณเหลือเวลาอีก",
              style: TextStyle(
                fontSize: 24,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatDuration(_timeRemaining),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "ผ่านไปแล้ว",
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
