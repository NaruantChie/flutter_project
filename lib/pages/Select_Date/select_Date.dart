import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SelectDatePage extends StatefulWidget {
  const SelectDatePage({super.key});

  @override
  State<SelectDatePage> createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;
  bool showCake = false;

  final List<String> years = List.generate(
    100,
    (index) =>
        (DateTime.now().year - index + 543).toString(), // ใช้ปี พ.ศ. โดยตรง
  );

  List<String> getLocalizedMonths(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      localizations.january,
      localizations.february,
      localizations.march,
      localizations.april,
      localizations.may,
      localizations.june,
      localizations.july,
      localizations.august,
      localizations.september,
      localizations.october,
      localizations.november,
      localizations.december,
    ];
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        showCake = true;
      });
    });
  }

  List<String> days =
      List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));
  void updateDays() {
    if (selectedYear != null && selectedMonth != null) {
      int daysInMonth = 31; // ค่าที่กำหนดไว้ล่วงหน้า
      setState(() {
        days = List.generate(
            daysInMonth, (index) => (index + 1).toString().padLeft(2, '0'));
        if (selectedDay != null && int.parse(selectedDay!) > daysInMonth) {
          selectedDay = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        toolbarHeight: 80,
        flexibleSpace: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    localizations.selectDateHeader,
                    style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    localizations.selectDateSubHeader,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(250),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      labelText: localizations.yearLabel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 8,
                      ),
                    ),
                    value: selectedYear,
                    isExpanded: true,
                    items: years.map((year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(
                          year,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                      });
                      updateDays();
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      height: 45,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      offset: const Offset(0, -6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 36,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      labelText: localizations.monthLabel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 4,
                      ),
                    ),
                    value: selectedMonth,
                    isExpanded: true,
                    items: getLocalizedMonths(context).map((month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(
                          month,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value;
                      });
                      updateDays();
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      height: 45,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      offset: const Offset(0, -5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 36,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      labelText: localizations.dayLabel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 8,
                      ),
                    ),
                    value: selectedDay,
                    isExpanded: true,
                    items: days.map((day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(
                          day,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDay = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      height: 45,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      offset: const Offset(0, -6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 36,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              opacity: (selectedYear != null &&
                      selectedMonth != null &&
                      selectedDay != null &&
                      showCake)
                  ? 1.0
                  : 0.0,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Icon(
                FontAwesomeIcons.baby,
                size: 420,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            Positioned(
              top: 170,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: (selectedYear != null &&
                          selectedMonth != null &&
                          selectedDay != null)
                      ? (Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white)
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (selectedYear != null &&
                        selectedMonth != null &&
                        selectedDay != null)
                    ? () {
                        // พิมพ์ค่าที่จะถูกส่งไปยังหน้า SelectionPage
                        print({
                          'year': selectedYear,
                          'month': selectedMonth,
                          'day': selectedDay,
                        });

                        // เรียก navigation ไปยัง SelectionPage
                        GoRouter.of(context).go(
                          '/selection',
                          extra: {
                            'year': selectedYear,
                            'month': selectedMonth,
                            'day': selectedDay,
                          },
                        );
                      }
                    : null,
                child: Text(
                  AppLocalizations.of(context)!.nextButton,
                  style: TextStyle(
                    fontSize: 18,
                    color: (selectedYear != null &&
                            selectedMonth != null &&
                            selectedDay != null)
                        ? (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
