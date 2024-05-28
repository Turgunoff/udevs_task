part of 'add_event_bloc.dart';

abstract class AddEventState {}

class AddEventInitial extends AddEventState {}

class AddEventLoading extends AddEventState {}

class AddEventSuccess extends AddEventState {}

class AddEventError extends AddEventState {
  final String error;

  AddEventError(this.error);
}
