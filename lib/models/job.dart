// lib/models/job.dart
// Fingerprint: JOB-MODEL-v3

class Job {
  final int id;              // numeric id (e.g., 1001)
  final String title;        // short title
  final String status;       // 'open' | 'accepted' | 'arrived' | 'completed' | 'canceled'
  final String address;      // street address only
  final String? city;        // optional city, shown when present
  final String? notes;       // optional notes
  final double? price;       // optional price

  const Job({
    required this.id,
    required this.title,
    required this.status,
    required this.address,
    this.city,
    this.notes,
    this.price,
  });

  Job copyWith({
    int? id,
    String? title,
    String? status,
    String? address,
    String? city,
    String? notes,
    double? price,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      address: address ?? this.address,
      city: city ?? this.city,
      notes: notes ?? this.notes,
      price: price ?? this.price,
    );
  }

  /// Be liberal in what we accept (string or int for `id`, string/num for `price`)
  factory Job.fromJson(Map<String, dynamic> j) {
    int parseId(dynamic v) {
      if (v is int) return v;
      if (v is String) {
        final digits = RegExp(r'\d+').firstMatch(v)?.group(0);
        if (digits != null) return int.parse(digits);
        return int.tryParse(v) ?? 0;
      }
      return 0;
    }

    double? parsePrice(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    return Job(
      id: parseId(j['id']),
      title: (j['title'] ?? '').toString(),
      status: (j['status'] ?? '').toString().toLowerCase(),
      address: (j['address'] ?? '').toString(),
      city: (j['city'] as String?)?.trim(),
      notes: (j['notes'] as String?)?.trim(),
      price: parsePrice(j['price']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'status': status,
        'address': address,
        'city': city,
        'notes': notes,
        'price': price,
      };
}
