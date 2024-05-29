import 'package:bloc/bloc.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/domain/usecases/add_event.dart';
import 'package:udevs_task/domain/usecases/update_event.dart';

part 'add_event_event.dart';
part 'add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  final AddEvent _addEvent;
  final UpdateEvent _updateEvent; // Add UpdateEvent

  AddEventBloc({required AddEvent addEvent, required UpdateEvent updateEvent})
      : _addEvent = addEvent,
        _updateEvent = updateEvent, // Add UpdateEvent
        super(AddEventInitial()) {
    // Register event handler for AddEventSubmitted
    on<AddEventSubmitted>(_handleAddEventSubmitted);
    on<UpdateEventSubmitted>(
        _handleUpdateEventSubmitted); // Add UpdateEventSubmitted Handler
  }

  Future<void> _handleAddEventSubmitted(
      AddEventSubmitted event, Emitter<AddEventState> emit) async {
    emit(AddEventLoading());
    try {
      await _addEvent(event.event);
      emit(AddEventSuccess());
    } catch (e) {
      emit(AddEventError(e.toString()));
    }
  }

  Future<void> _handleUpdateEventSubmitted(
      UpdateEventSubmitted event, Emitter<AddEventState> emit) async {
    emit(AddEventLoading());
    try {
      await _updateEvent(event.event);
      emit(AddEventSuccess());
    } catch (e) {
      emit(AddEventError(e.toString()));
    }
  }
}
