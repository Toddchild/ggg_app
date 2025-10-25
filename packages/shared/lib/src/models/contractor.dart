class Contractor {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final double? rating;
  final int? completedJobs;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Contractor({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.rating,
    this.completedJobs,
    this.isAvailable = true,
    required this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating a Contractor from JSON
  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      completedJobs: json['completedJobs'] as int?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
    );
  }

  // Method for converting a Contractor to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'rating': rating,
      'completedJobs': completedJobs,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method for creating modified copies
  Contractor copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    double? rating,
    int? completedJobs,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Contractor(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      completedJobs: completedJobs ?? this.completedJobs,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Contractor(id: $id, name: $name, email: $email, phone: $phone, '
        'address: $address, rating: $rating, completedJobs: $completedJobs, '
        'isAvailable: $isAvailable, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contractor &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.rating == rating &&
        other.completedJobs == completedJobs &&
        other.isAvailable == isAvailable &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      phone,
      address,
      rating,
      completedJobs,
      isAvailable,
      createdAt,
      updatedAt,
    );
  }
}
