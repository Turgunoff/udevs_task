import 'dart:ui';

class Event {
  final int?
      id; // Tadbirning ID raqami (null bo'lishi mumkin, chunki ma'lumotlar bazasi uni avtomatik yaratadi)
  final String name; // Tadbirning nomi
  final String description; // Tadbirning tavsifi
  final String location; // Tadbirning joylashuvi
  final Color color; // Tadbirning rangi
  final DateTime dateTime; // Tadbirning vaqti

  Event({
    this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.color,
    required this.dateTime,
  });

  // Bu yerda kerak bo'lsa, qo'shimcha metodlar yoki konstruktorlar qo'shishingiz mumkin
}
