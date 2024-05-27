import 'package:dartz/dartz.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/data/repositories/event_repository.dart';

class AddEvent {
  final EventRepository repository;

  AddEvent(this.repository);

  Future<void> call(Event event) async {
    // Validatsiya (misol uchun)
    if (event.name.isEmpty) {
      throw Exception('Tadbir nomi bo\'sh bo\'lmasligi kerak');
    }

    try {
      await repository.addEvent(event);
    } catch (e) {
      // Xatolik yuz berganda Exception tashlaymiz
      throw Exception('Tadbirni qo\'shishda xatolik yuz berdi: $e');
    }
  }
}
