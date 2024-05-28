import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:udevs_task/data/datasources/event_local_datasource.dart';
import 'package:udevs_task/data/repositories/event_repository.dart';
import 'package:udevs_task/data/repositories/event_repository_impl.dart';
import 'package:udevs_task/domain/usecases/add_event.dart';
import 'package:udevs_task/presentation/bloc/add_event/add_event_bloc.dart';
import 'package:udevs_task/presentation/screens/home_screen.dart';

import 'domain/usecases/delete_event.dart';
import 'domain/usecases/get_event.dart';
import 'domain/usecases/update_event.dart';

final getIt = GetIt.instance;

void setup() {
  // Data source
  getIt.registerLazySingleton<EventLocalDatasource>(
    () => EventLocalDatasource(),
  );

  // Repository
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerFactory<AddEvent>(
    () => AddEvent(getIt()),
  );
  getIt.registerFactory<GetEvents>(
    // Register GetEvents
    () => GetEvents(getIt()),
  );
  getIt.registerFactory<UpdateEvent>(
    () => UpdateEvent(getIt()),
  );
  getIt.registerFactory<DeleteEvent>(
    () => DeleteEvent(getIt()),
  );

  // BLoCs
  getIt.registerFactory<AddEventBloc>(() => AddEventBloc(
        addEvent: getIt(),
        updateEvent: getIt(),
      ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddEventBloc>(
          create: (context) => getIt(), // Use getIt to retrieve AddEventBloc
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Udevs Task',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
