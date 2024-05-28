import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:udevs_task/presentation/screens/detail_screen.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/domain/usecases/get_event.dart';
import 'package:udevs_task/presentation/screens/add_event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _currentDate = DateTime.now();
  List<Event>? _events; // Tadbirlarni saqlash uchun o'zgaruvchi

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Ekran yuklanganda tadbirlarni yuklash
  }

  Future<void> _loadEvents() async {
    final getEvents = GetIt.I<GetEvents>();
    try {
      final events = await getEvents();
      setState(() {
        _events = events;
      });
    } catch (e) {
      print('Xatolik: $e');
    }
  }

  Color _getColorFromCode(String colorCode) {
    switch (colorCode) {
      case 'B':
        return Colors.blue;
      case 'R':
        return Colors.red;
      case 'Y':
        return Colors.purple;
      default:
        return Colors.blue; // Standart rang (ko'k)
    }
  }

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
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => const AddEventScreen(),
                          ),
                        )
                        .then((value) =>
                            _loadEvents()); // Ekran yopilganda tadbirlarni qayta yuklash
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
              itemCount: _events?.length ?? 0,
              itemBuilder: (context, index) {
                final event =
                    _events![index]; // Endi bu yerda events ishlatiladi
                final eventColor = _getColorFromCode(event.type);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(event: event),
                      ),
                    ).then((deletedEventId) {
                      if (deletedEventId != null) {
                        _loadEvents(); // Tadbirlarni qayta yuklash
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: eventColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: eventColor,
                            borderRadius: const BorderRadius.only(
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
                                event.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: eventColor.withAlpha(255),
                                ),
                              ),
                              Text(
                                // 'Manchester United vs Arsenal (Premiere League)',
                                event.type,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: eventColor.withAlpha(255),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    size: 20,
                                    Icons.access_time_filled_sharp,
                                    color: eventColor.withAlpha(255),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'data',
                                    // '${dateFormat(event.startTime.toString())} - ${dateFormat(event.endTime.toString())}', // Vaqt oralig'ini ko'rsatish,
                                    style: TextStyle(
                                      color: eventColor.withAlpha(255),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: eventColor.withAlpha(255),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.location,
                                    style: TextStyle(
                                      color: eventColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
