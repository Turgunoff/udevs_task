import 'package:udevs_task/data/repositories/event_repository.dart';

class DeleteEvent {
  final EventRepository repository;

  DeleteEvent(this.repository);

  Future<void> call(int eventId) async {
    try {
      await repository.deleteEvent(eventId);
    } on Exception catch (e) {
      throw Exception('Tadbirni o\'chirishda xatolik yuz berdi: $e');
    }
  }
}
