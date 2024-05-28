lib/

├── data/

│ ├── datasources/

│ │ └── event_local_datasource.dart

│ └── repositories/

│ └── event_repository_impl.dart

├── domain/

│ ├── entities/

│ │ └── event.dart

│ └── usecases/

│ ├── add_event.dart

│ ├── delete_event.dart

│ ├── get_events.dart

│ └── update_event.dart

├── presentation/

│ ├── bloc/

│ │ ├── add_event/

│ │ │ ├── add_event_bloc.dart

│ │ │ ├── add_event_event.dart

│ │ │ └── add_event_state.dart

│ │ └── home_screen/

│ │ ├── home_screen_bloc.dart

│ │ ├── home_screen_event.dart

│ │ └── home_screen_state.dart

│ └── screens/

│ ├── add_event_screen.dart

│ ├── detail_screen.dart

│ └── home_screen.dart

└── main.dart
