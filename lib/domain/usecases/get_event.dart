import 'package:udevs_task/data/repositories/event_repository.dart';
import 'package:udevs_task/domain/entities/event.dart';

class GetEvents {
  final EventRepository repository;

  GetEvents(this.repository);

  Future<List<Event>> call() async {
    try {
      final events = await repository.getEvents();
      return events;
    } on Exception catch (e) {
      throw Exception('Error in getting the event: $e');
    }
  }
}
