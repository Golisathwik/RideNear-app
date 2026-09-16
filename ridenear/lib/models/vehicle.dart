class Vendor {
  final String id;
  final String name;
  final bool verified;
  final double rating;
  final int reviews;
  final double latitude;
  final double longitude;

  const Vendor({
    required this.id,
    required this.name,
    required this.verified,
    required this.rating,
    required this.reviews,
    this.latitude = 17.4483, // default to Madhapur, Hyderabad approx
    this.longitude = 78.3915,
  });
}

class Vehicle {
  final String id;
  final String name;
  final String type; // e.g., 'Car', 'Bike', 'Scooter'
  final String category; // e.g., 'Hatchback', 'Cruiser', 'SUV'
  final String image;
  final Vendor vendor;
  final String distance;
  final int pricePerDay;
  final int pricePerHour;
  final String transmission;
  final String fuel;
  final int seats;
  final bool available;

  const Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.image,
    required this.vendor,
    required this.distance,
    required this.pricePerDay,
    required this.pricePerHour,
    required this.transmission,
    required this.fuel,
    this.seats = 2,
    required this.available,
  });

  Vehicle copyWith({
    String? distance,
  }) {
    return Vehicle(
      id: id,
      name: name,
      type: type,
      category: category,
      image: image,
      vendor: vendor,
      distance: distance ?? this.distance,
      pricePerDay: pricePerDay,
      pricePerHour: pricePerHour,
      transmission: transmission,
      fuel: fuel,
      seats: seats,
      available: available,
    );
  }
}
