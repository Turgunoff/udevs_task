import 'package:udevs_task/data/repositories/event_repository.dart';
import 'package:udevs_task/domain/entities/event.dart';

class UpdateEvent {
  final EventRepository repository;

  UpdateEvent(this.repository);

  Future<void> call(Event event) async {
    try {
      await repository.updateEvent(event);
    } on Exception catch (e) {
      throw Exception('Error in updating the event: $e');
    }
  }
}
