// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/domain/usecases/delete_event.dart';
import 'package:udevs_task/presentation/screens/update_event_screen.dart';

class DetailScreen extends StatelessWidget {
  final Event event;

  const DetailScreen({super.key, required this.event});
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

  @override
  Widget build(BuildContext context) {
    final eventColor = _getColorFromCode(event.type);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: eventColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateEventScreen(event: event),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text(
                    event.name,
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  // const Text(
                  //   'Manchester United vs Arsenal (Premiere League)',
                  //   style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                          '${DateFormat('kk:mm').format(event.startTime)} - ${DateFormat('kk:mm').format(event.endTime)}',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(event.location,
                          style: const TextStyle(color: Colors.white)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(26),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reminder',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  const Text('15 minutes befor',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(event.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.2,
                        color: Colors.grey[500],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          final deleteEvent = GetIt.I<DeleteEvent>();

          try {
            await deleteEvent(event.id!); // Delete event
            Navigator.of(context).pop(event.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('The event was successfully deleted')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.all(25),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.red[900], size: 16),
              Text(
                'Delete event',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
