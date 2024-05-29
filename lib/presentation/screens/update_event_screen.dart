import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/presentation/bloc/add_event/add_event_bloc.dart';
import 'package:udevs_task/presentation/screens/add_event_screen.dart';

class UpdateEventScreen extends StatelessWidget {
  final Event event;

  const UpdateEventScreen({super.key, required this.event}); // Konstruktor

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AddEventBloc>(context),
      child: AddEventScreen(event: event), // AddEventScreen'ni qayta ishlatish
    );
  }
}
