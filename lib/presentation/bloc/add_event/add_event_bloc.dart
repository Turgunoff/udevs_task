import 'package:bloc/bloc.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/domain/usecases/add_event.dart';

part 'add_event_event.dart';
part 'add_event_state.dart';

class AddEventBloc extends Bloc<Event, AddEventState> {
  final AddEvent _addEvent;

  AddEventBloc({required AddEvent addEvent})
      : _addEvent = addEvent,
        super(AddEventInitial()) {
    // Register event handler for Event
    on<Event>(_handleAddEvent);
  }

  Future<void> _handleAddEvent(Event event, Emitter<AddEventState> emit) async {
    emit(AddEventLoading()); // Tadbir qo'shilish jarayonida

    try {
      await _addEvent(event);
      emit(AddEventSuccess());
    } catch (e) {
      emit(AddEventError(e.toString()));
    }
  }
}
