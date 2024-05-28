import 'dart:ui';

class Event {
  final int? id;
  final String name;
  final String description;
  final String location;
  // final DateTime startTime; // Tadbir boshlanish vaqti
  // final DateTime endTime; // Tadbir tugash vaqti
  final String type;

  Event({
    this.id,
    required this.name,
    required this.description,
    required this.location,
    // required this.startTime,
    // required this.endTime,
    required this.type,
  });

  // JSON seriyallashtirish uchun toJson metodi
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'location': location,
        // 'startTime': startTime.toIso8601String(),
        // 'endTime': endTime.toIso8601String(),
        'type': type,
      };

  // JSON deseriyallashtirish uchun fromJson factory konstruktori
  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        location: json['location'],
        // startTime: DateTime.parse(json['startTime']),
        // endTime: DateTime.parse(json['endTime']),
        type: json['type'],
      );

  // Obyektni nusxalash uchun copyWith metodi
  Event copyWith({
    int? id,
    String? name,
    String? description,
    String? location,
    // DateTime? startTime,
    // DateTime? endTime,
    String? type,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      // startTime: startTime ?? this.startTime,
      // endTime: endTime ?? this.endTime,
      type: type ?? this.type,
    );
  }
}
