// ignore_for_file: avoid_print

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
  final List<Event> events = [];

  List<Event>? _events; // Variable to save events
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Upload events when the screen loads
  }

  Future<void> _loadEvents() async {
    final getEvents = GetIt.I<GetEvents>();
    try {
      final events = await getEvents();
      setState(() {
        _events = events;
        _filterEvents();
      });
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  // Event filtering function
  void _filterEvents() {
    setState(() {
      _filteredEvents = _events
              ?.where((event) => isSameDay(event.startTime, _currentDate))
              .toList() ??
          [];
    });
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      _currentDate = date;
    });
    _filterEvents();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
        return Colors.blue;
    }
  }

  void _previousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
    _filterEvents();
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
    _filterEvents();
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final firstDayOfWeek = firstDayOfMonth.weekday;
    final totalDays =
        daysInMonth + firstDayOfWeek - 1; // For empty cells in the first week
    final rows = (totalDays / 7).ceil();
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
              DateFormat('d MMMM yyyy').format(DateTime.now()),
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
                  DateFormat('MMMM').format(_currentDate),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('yyyy').format(_currentDate),
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
              // Weekday names
              children: List.generate(7, (index) {
                return Expanded(
                  child: Center(
                    child: Text(
                      DateFormat.E()
                          .format(DateTime(
                              2024, 5, 20 + index)) // Getting days of the week
                          .substring(0, 3),
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.grey),
                    ),
                  ),
                );
              }),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.2, // Ratio of cells
              ),
              itemCount: rows * 7, // Number of all cells
              itemBuilder: (context, index) {
                final day = index - firstDayOfWeek + 2;
                final date =
                    DateTime(_currentDate.year, _currentDate.month, day);
                bool isSelected = isSameDay(date, _currentDate);

                if (index < firstDayOfWeek - 1 || day > daysInMonth) {
                  return Container(); // Empty cell
                } else {
                  final eventsForDay = events
                      .where((event) => isSameDay(event.startTime, date))
                      .toList();

                  return GestureDetector(
                    onTap: () {
                      _onDaySelected(date);
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Colors.blue
                                  : null, // Checking today
                            ),
                            child: Text(
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                              day.toString(),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: eventsForDay.map((event) {
                              final eventColor = _getColorFromCode(event.type);
                              return Container(
                                width: 6,
                                height: 6,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: eventColor,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
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
                            _loadEvents()); // Reload events when the screen is closed
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
            if (_events == null) // Checking event loading
              const Center(child: CircularProgressIndicator())
            else if (_filteredEvents.isEmpty)
              const Center(child: Text("No data"))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _events?.length ?? 0,
                itemBuilder: (context, index) {
                  final event = _events![index]; // Now events are used here
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
                          _loadEvents();
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
                                  event.description,
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
                                      '${DateFormat('kk:mm').format(event.startTime)} - ${DateFormat('kk:mm').format(event.endTime)}', // Vaqt oralig'ini ko'rsatish,
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
