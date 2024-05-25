import 'package:udevs_task/domain/entities/event.dart';

abstract class EventRepository {
  Future<void> addEvent(Event event);
  // Future<List<Event>> getEvents();
  // Boshqa metodlar
}
