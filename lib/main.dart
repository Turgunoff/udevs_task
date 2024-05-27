import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs_task/data/datasources/event_local_datasource.dart';
import 'package:udevs_task/data/repositories/event_repository_impl.dart';
import 'package:udevs_task/domain/usecases/add_event.dart';

import 'package:udevs_task/presentation/screens/home_screen.dart';
import 'package:udevs_task/presentation/bloc/add_event/add_event_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final eventRepository = EventRepositoryImpl(
        EventLocalDatasource()); // EventRepository obyektini yaratamiz
    final addEventUseCase =
        AddEvent(eventRepository); // AddEvent obyektiga uzatamiz
    return MaterialApp(
      home: BlocProvider<AddEventBloc>(
        // Provide the Bloc here
        create: (context) => AddEventBloc(addEvent: addEventUseCase),
        child: HomeScreen(), // HomeScreen now has access to AddEventBloc
      ),
    );
  }
}
