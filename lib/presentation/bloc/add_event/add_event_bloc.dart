import 'package:bloc/bloc.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/domain/usecases/add_event.dart';

part 'add_event_event.dart';
part 'add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  final AddEvent _addEvent;

  AddEventBloc({required AddEvent addEvent})
      : _addEvent = addEvent,
        super(AddEventInitial());

  Stream<AddEventState> mapEventToState(AddEventEvent event) async* {
    if (event is AddEventSubmitted) {
      yield AddEventLoading(); // Tadbir qo'shilish jarayonida

      try {
        await _addEvent(event.event);
        yield AddEventSuccess();
      } catch (e) {
        yield AddEventError(e.toString()); // Xatolik xabarini holatga o'tkazish
      }
    }
  }
}
