part of 'add_event_bloc.dart'; // add_event_bloc.dart fayliga bog'lash

abstract class AddEventEvent {}

// Tadbir qo'shish voqeasi
class AddEventSubmitted extends AddEventEvent {
  final Event event;

  AddEventSubmitted(this.event);
}
