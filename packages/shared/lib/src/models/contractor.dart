class Contractor {
  final String id;
  final String name;
  final String phone;
  final bool approved;

  Contractor({
    required this.id,
    required this.name,
    required this.phone,
    this.approved = false,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) => Contractor(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        approved: json['approved'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'approved': approved,
      };
}
