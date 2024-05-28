import 'package:bloc/bloc.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/domain/usecases/add_event.dart';

part 'add_event_event.dart';
part 'add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  final AddEvent _addEvent;

  AddEventBloc({required AddEvent addEvent})
      : _addEvent = addEvent,
        super(AddEventInitial()) {
    // Register event handler for AddEventSubmitted
    on<AddEventSubmitted>(_handleAddEventSubmitted);
  }

  Future<void> _handleAddEventSubmitted(
      AddEventSubmitted event, Emitter<AddEventState> emit) async {
    emit(AddEventLoading()); // Tadbir qo'shilish jarayonida
    try {
      await _addEvent(event.event);
      emit(AddEventSuccess());
    } catch (e) {
      emit(AddEventError(e.toString())); // Xatolik xabarini holatga o'tkazish
    }
  }
}
