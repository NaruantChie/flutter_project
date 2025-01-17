import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:life_countdown/pages/Description/description.dart';
import 'package:life_countdown/pages/Select_Date/select_Date.dart';
import 'package:life_countdown/pages/HOME/home_page.dart';
import 'package:life_countdown/pages/PROVIDERS/locale_provider.dart';
import 'package:life_countdown/pages/PROVIDERS/theme_provider.dart';
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
      builder: (context, state) => SelectionPage(),
    ),
    GoRoute(
      path: '/death_year',
      builder: (context, state) => const DeathYearPage(),
    ),
  ],
);
