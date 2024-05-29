import 'package:udevs_task/data/datasources/event_local_datasource.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/data/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventLocalDatasource datasource;

  EventRepositoryImpl(this.datasource);

  @override
  Future<void> addEvent(Event event) async {
    try {
      await datasource.addEvent(event);
    } on Exception catch (e) {
      throw Exception('Error in adding the event: $e');
    }
  }

  @override
  Future<List<Event>> getEvents() async {
    try {
      final events = await datasource.getEvents();
      return events;
    } on Exception catch (e) {
      throw Exception('Error in getting the event: $e');
    }
  }

  @override
  Future<void> updateEvent(Event event) async {
    try {
      await datasource.updateEvent(event);
    } on Exception catch (e) {
      throw Exception('Error in updating the event: $e');
    }
  }

  @override
  Future<void> deleteEvent(int id) async {
    try {
      await datasource.deleteEvent(id);
    } on Exception catch (e) {
      throw Exception('Error in deleting the event: $e');
    }
  }
}
