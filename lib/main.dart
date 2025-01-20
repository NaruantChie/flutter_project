import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:life_countdown/pages/Description/description.dart';
import 'package:life_countdown/pages/HOME/home_page.dart';
import 'package:life_countdown/pages/LifeCountdown/LifeCountdownPage%20.dart';
import 'package:life_countdown/pages/PROVIDERS/locale_provider.dart';
import 'package:life_countdown/pages/PROVIDERS/theme_provider.dart';
import 'package:life_countdown/pages/Result/resultPage.dart';
import 'package:life_countdown/pages/Select_Date/select_Date.dart';
import 'package:life_countdown/pages/Selection/deathDayPage.dart';
import 'package:life_countdown/pages/Selection/deathMonthPage.dart';
import 'package:life_countdown/pages/Selection/deathTimePage.dart';
import 'package:life_countdown/pages/Selection/deathYearPage.dart';
import 'package:life_countdown/pages/Selection/selection.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: _router, // ใช้ GoRouter
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.themeMode, // ใช้ ThemeNotifier
      locale: localeNotifier.locale, // ใช้ LocaleNotifier
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('th', ''),
      ],
    );
  }
}

// ตั้งค่า GoRouter
final GoRouter _router = GoRouter(
  initialLocation: '/', // กำหนดเส้นทางเริ่มต้น
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/select_Date',
      builder: (context, state) => const SelectDatePage(),
    ),
    GoRoute(
      path: '/description',
      builder: (context, state) => Description(),
    ),
    GoRoute(
      path: '/selection',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;

        final selectedYear = args?['year'];
        final selectedMonth = args?['month'];
        final selectedDay = args?['day'];

        return SelectionPage(
          year: selectedYear,
          month: selectedMonth,
          day: selectedDay,
        );
      },
    ),
    GoRoute(
      path: '/death_year',
      builder: (context, state) {
        return DeathYearPage(
          onSelected: (selectedYear) {
            print('Selected year: $selectedYear');
          },
        );
      },
    ),
    GoRoute(
      path: '/death_month',
      builder: (context, state) {
        return DeathMonthPage(
          onSelected: (selectedMonth, selectedMonthName) {
            context.go(
              '/death_day',
              extra: {
                'selectedMonth': selectedMonth,
                'selectedMonthName': selectedMonthName,
              },
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/death_day',
      builder: (context, state) {
        final extra =
            state.extra as Map<String, dynamic>?; // รับข้อมูลจาก state.extra
        final selectedMonth =
            extra?['selectedMonth'] ?? 1; // เดือนในรูปแบบตัวเลข
        final selectedMonthName =
            extra?['selectedMonthName'] ?? 'มกราคม'; // ชื่อเดือน

        return DeathDayPage(
          month: selectedMonth,
          monthName: selectedMonthName,
          year: 2025, // สามารถกำหนดปีที่ต้องการได้
          onSelected: (selectedDay) {
            // ตัวอย่าง: แสดงผลวันที่เลือกใน console
            print('Selected day: $selectedDay');
          },
        );
      },
    ),
    GoRoute(
      path: '/death_time',
      builder: (context, state) => DeathTimePage(
        onSelected: (value) {
          // ดำเนินการเมื่อเลือกเวลา
          print('Selected time: $value');
        },
      ),
    ),
    GoRoute(
      path: '/resultPage',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;

        final fromSelectDate = args?['fromSelectDate'] as Map<String, dynamic>?;
        final fromSelectionPage =
            args?['fromSelectionPage'] as Map<String, dynamic>?;

        return ResultPage(
          fromSelectDate: fromSelectDate,
          fromSelectionPage: fromSelectionPage,
        );
      },
    ),
    GoRoute(
      path: '/lifeCount_downPage',
      builder: (context, state) {
        final data = state.extra as Map<String, DateTime>;
        return LifeCountdownPage(
          deathDate: data['deathDate']!,
          birthDate: data['birthDate']!,
        );
      },
    ),
  ],
);
