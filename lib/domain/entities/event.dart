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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'location': location,
        'color': color.value
            .toString(), // Convert Color to string representation (e.g., hex code)
        'dateTime': dateTime.toIso8601String(),
      };

  // Bu yerda kerak bo'lsa, qo'shimcha metodlar yoki konstruktorlar qo'shishingiz mumkin
}
