import 'package:dartz/dartz.dart';
import 'package:udevs_task/data/datasources/event_local_datasource.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/data/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventLocalDatasource datasource;

  EventRepositoryImpl(this.datasource);

  @override
  Future<Either<Exception, void>> addEvent(Event event) async {
    try {
      await datasource.addEvent(
          event); // Ma'lumotlar bazasiga tadbirni qo'shishga harakat qilamiz.
      return const Right(
          null); // Agar muvaffaqiyatli qo'shilsa, Right(null) qaytaramiz.
    } catch (e) {
      // Xatolik yuz berganda:
      print('Xatolik yuz berdi: $e'); // Xatolikni konsolga chiqaramiz.
      // Qo'shimcha xatoliklarni qayta ishlash (loglash, foydalanuvchiga xabar berish)
      return Left(Exception(
          'Tadbirni qo\'shishda xatolik yuz berdi')); // Xatolik obyektini qaytaramiz.
    }
  }
}
