part of 'add_event_bloc.dart'; // add_event_bloc.dart fayliga bog'lash

abstract class AddEventEvent {}

class AddEventSubmitted extends AddEventEvent {
  // Form yuborilganda
  final Event event;

  AddEventSubmitted(this.event);
}
