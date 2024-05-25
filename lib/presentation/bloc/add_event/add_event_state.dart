part of 'add_event_bloc.dart';

abstract class AddEventState {}

class AddEventInitial extends AddEventState {}

class AddEventLoading extends AddEventState {} // Ma'lumotlar yuklanayotgan payt

class AddEventSuccess
    extends AddEventState {} // Tadbir muvaffaqiyatli qo'shilgan

class AddEventError extends AddEventState {
  final String error;

  AddEventError(this.error);
}
