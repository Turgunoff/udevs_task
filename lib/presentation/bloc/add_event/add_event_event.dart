part of 'add_event_bloc.dart'; // add_event_bloc.dart fayliga bog'lash

abstract class AddEventEvent {}

class AddEventSubmitted extends AddEventEvent {
  final Event event;

  AddEventSubmitted(this.event);
}

class UpdateEventSubmitted extends AddEventEvent {
  final Event event;

  UpdateEventSubmitted(this.event);
}
