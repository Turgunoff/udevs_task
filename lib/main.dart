import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:udevs_task/add_event_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _currentDate = DateTime.now();

  void _previousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_currentDate.year, _currentDate.month + 1,
            0) // Keyingi oyning 0-kuni
        .day;
    final firstDayOfWeek = _currentDate.weekday;
    final totalDays = daysInMonth +
        firstDayOfWeek -
        1; // Birinchi haftadagi bo'sh kataklar uchun
    final rows = (totalDays / 7).ceil(); // Qatorlar soni

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              DateFormat('EEEE').format(DateTime.now()),
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              DateFormat('d MMMM yyyy')
                  .format(DateTime.now()), // Joriy sana va kun (O'zbek tilida)
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM')
                      .format(_currentDate), // Joriy oy (O'zbek tilida)
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('yyyy')
                      .format(_currentDate), // Joriy oy (O'zbek tilida)
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _previousMonth,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[200],
                        ),
                        child: const Icon(Icons.chevron_left),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _nextMonth,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[200],
                        ),
                        child: const Icon(Icons.chevron_right),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              // Hafta kunlari nomlari
              children: List.generate(7, (index) {
                return Expanded(
                  child: Center(
                    child: Text(
                      DateFormat.E().format(DateTime(
                          2024, 5, 20 + index)), // Hafta kunlarini olish
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.grey),
                    ),
                  ),
                );
              }),
            ),
            GridView.builder(
              shrinkWrap: true, // GridView hajmini moslashtirish
              physics:
                  const NeverScrollableScrollPhysics(), // GridView ichida scrollni o'chirish
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // 7 ustun
                childAspectRatio: 1.2, // Kataklarning nisbati
              ),
              itemCount: rows * 7, // Barcha kataklar soni
              itemBuilder: (context, index) {
                final day = index - firstDayOfWeek + 2;
                final date =
                    DateTime(_currentDate.year, _currentDate.month, day);

                if (index < firstDayOfWeek - 1 || day > daysInMonth) {
                  return Container(); // Bo'sh katak
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isToday(date)
                                ? Colors.blue
                                : null, // Bugungi kunni tekshirish
                          ),
                          child: Text(
                            style: TextStyle(
                              color:
                                  isToday(date) ? Colors.white : Colors.black,
                            ),
                            day.toString(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 4,
                              width: 4,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                            ),
                            if (isToday(date))
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                height: 4,
                                width: 4,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Yangi tadbir yaratish ekraniga o'tish
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddEventScreen(),
                        ));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Add Event',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Watching Football',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue[800],
                              ),
                            ),
                            Text(
                              'Manchester United vs Arsenal (Premiere League)',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.blue[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  size: 20,
                                  Icons.access_time_filled_sharp,
                                  color: Colors.blue[800],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '10:00 - 11:00',
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Colors.blue[800],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Stamford Bridge',
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
