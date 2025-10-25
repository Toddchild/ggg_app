// Minimal contractor model used by the apps.
// Expand with fields and JSON (de)serialization as needed.

class Contractor {
  final String id;
  final String name;

  Contractor({required this.id, required this.name});

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  String toString() => 'Contractor(id: $id, name: $name)';
}
