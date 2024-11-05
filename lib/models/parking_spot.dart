class ParkingSpot {
  final String locationId;
  final String locationName;
  final String pincode;
  final String address;
  final int city;
  final int totalParkingLots;
  final String totalRevenue;
  final bool isOpen;
  final int availableSlots;
  final double latitude;
  final double longitude;
  final double distanceKm;

  ParkingSpot({
    required this.locationId,
    required this.locationName,
    required this.pincode,
    required this.address,
    required this.city,
    required this.totalParkingLots,
    required this.totalRevenue,
    required this.isOpen,
    required this.availableSlots,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
  });
}