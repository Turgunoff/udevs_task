import 'package:flutter/material.dart';
import 'package:udevs_task/domain/entities/event.dart';

class UpdateEventScreen extends StatelessWidget {
  final Event event;
  const UpdateEventScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Event'),
      ),
      body: Center(
        child: Text('Update Event Screen'),
      ),
    );
  }
}
