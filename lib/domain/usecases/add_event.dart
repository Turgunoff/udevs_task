import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/data/repositories/event_repository.dart';

class AddEvent {
  final EventRepository repository;

  AddEvent(this.repository);

  Future<void> call(Event event) async {
    // Validation (for example)
    if (event.name.isEmpty) {
      throw Exception('Event name should not be empty');
    }
    if (event.startTime.isAfter(event.endTime)) {
      throw Exception('The start time should be before the end time');
    }

    try {
      await repository.addEvent(event);
    } catch (e) {
      throw Exception('Error in adding the event: $e');
    }
  }
}
