import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool isLoading = true;
  String remoteMessage = "Loading...";

  @override
  void initState() {
    super.initState();
    _initRemoteConfig();
  }

  Future<void> _initRemoteConfig() async {
    setState(() {
      isLoading = true;
    });

    try {
      // ตั้งค่าค่าเริ่มต้น
      await _remoteConfig.setDefaults({"name": "word"});

      // ตั้งค่าการ fetch
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 10),
      ));

      // ดึงค่าจาก Remote Config
      await _remoteConfig.fetchAndActivate();

      setState(() {
        remoteMessage = _remoteConfig.getString("name");
      });
    } catch (e) {
      print("Error fetching remote config: $e");
      setState(() {
        remoteMessage = "Error fetching data.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Life Countdown'),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Welcome to Life Countdown",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        remoteMessage,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color:
                              isDarkMode ? Colors.grey[300] : Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Divider(),
                    const SizedBox(height: 20),
                    const Text(
                      "About Us",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "สนับสนุน Peaceful Death\n"
                      "ท่านสามารถร่วมสมทบทุนการจัดทำสื่อและกิจกรรมการเรียนรู้ เรื่องการอยู่และตายดีของ Peaceful Death ได้โดยการโอนเงินตามข้อมูลด้านล่าง",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "ธนาคารกสิกรไทย สาขา บางขุน",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Action สำหรับปุ่มเริ่มต้น
                          Navigator.pushNamed(context, '/select_Date');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDarkMode ? Colors.blueGrey : Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          "Start Countdown",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
