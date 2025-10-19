// lib/booking_model.dart

/// Represents a single item selected by the user.
class SelectedItem {
  final String name;
  final int quantity;

  const SelectedItem({
    required this.name,
    required this.quantity,
  });

  @override
  String toString() => '$name x$quantity';
}

/// Holds all details for the current booking, including items and the price breakdown.
class BookingDetails {
  // Pricing Details (based on your website logic)
  final double itemsTotal;
  final double envTotal;
  final double grandTotal;

  // Volume/Tally Details (for informational metrics)
  final int totalVolume;
  final int fullTrucks;

  // Selected Items List
  final List<SelectedItem> selectedItems;

  const BookingDetails({
    // Required parameters
    required this.itemsTotal,
    required this.envTotal,
    required this.grandTotal,
    required this.totalVolume,
    required this.fullTrucks,
    required this.selectedItems,
  });

  /// A user-friendly, concise summary of the items selected.
  String get itemSummary {
    if (selectedItems.isEmpty) return 'No items selected';
    
    // Limits the summary to the first three items plus a count of others.
    final visibleItems = selectedItems.take(3).map((item) => '${item.name} ×${item.quantity}').toList();
    final remainingCount = selectedItems.length - 3;

    if (remainingCount > 0) {
      return '${visibleItems.join(', ')} (+$remainingCount other item${remainingCount > 1 ? 's' : ''})';
    }
    return visibleItems.join(', ');
  }

  /// Creates a copy of the booking details, allowing easy updates to specific fields.
  BookingDetails copyWith({
    double? itemsTotal,
    double? envTotal,
    double? grandTotal,
    int? totalVolume,
    int? fullTrucks,
    List<SelectedItem>? selectedItems,
  }) {
    return BookingDetails(
      itemsTotal: itemsTotal ?? this.itemsTotal,
      envTotal: envTotal ?? this.envTotal,
      grandTotal: grandTotal ?? this.grandTotal,
      totalVolume: totalVolume ?? this.totalVolume,
      fullTrucks: fullTrucks ?? this.fullTrucks,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }
}
