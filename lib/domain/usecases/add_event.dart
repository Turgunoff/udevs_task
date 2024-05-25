import 'package:dartz/dartz.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/domain/repositories/event_repository.dart';

class AddEvent {
  final EventRepository repository;

  AddEvent(this.repository);

  Future<Either<Exception, void>> call(Event event) async {
    // Validatsiya (misol uchun)
    if (event.name.isEmpty) {
      return Left(Exception('Tadbir nomi bo\'sh bo\'lmasligi kerak'));
    }

    try {
      await repository.addEvent(event);
      return const Right(null); // Muvaffaqiyatli qo'shildi
    } on Exception catch (e) {
      return Left(e); // Xatolik yuz berdi
    }
  }
}
