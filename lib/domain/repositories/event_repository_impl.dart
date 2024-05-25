import 'package:dartz/dartz.dart';
import 'package:udevs_task/data/datasources/event_local_datasource.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventLocalDatasource datasource;

  EventRepositoryImpl(this.datasource);

  @override
  Future<Either<Exception, void>> addEvent(Event event) async {
    try {
      await datasource.addEvent(event);
      return const Right(null); // Muvaffaqiyatli qo'shildi
    } on Exception catch (e) {
      return Left(e); // Xatolik yuz berdi
    }
  }

  // @override
  // Future<List<Event>> getEvents() async {
  //   final eitherEvents = await datasource.getEvents();
  //   return eitherEvents.fold(
  //     (failure) => [], // Return an empty list on failure
  //     (events) => events,
  //   );
  // }

  // Boshqa metodlarning implementatsiyasi (updateEvent, deleteEvent, va hokazo)
}
