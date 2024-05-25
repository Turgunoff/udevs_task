import 'package:dartz/dartz.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/domain/repositories/event_repository.dart';

class GetEvents {
  final EventRepository repository;

  GetEvents(this.repository);

  // Future<Either<Exception, List<Event>>> call() async {
  //   try {
  //     final events = await repository.getEvents();
  //     return Right(events); // Tadbirlarni muvaffaqiyatli qaytarish
  //   } on Exception catch (e) {
  //     // Xatolik yuz berganda qo'shimcha ishlov berish (log qilish, xabar berish va h.k.)
  //     // Masalan:
  //     // print('Xatolik: $e');
  //     // FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
  //     return Left(e); // Xatolikni qaytarish
  //   }
  // }
}
