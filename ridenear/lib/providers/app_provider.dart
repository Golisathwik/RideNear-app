import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserProfile;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'dart:math' as math;
import '../models/vehicle.dart';
import '../models/user_profile.dart';

enum BookingStatus { inProcess, closed }

class Booking {
  final String id;
  final Vehicle vehicle;
  final DateTime pickupDate;
  final DateTime returnDate;
  final int totalPrice;
  final BookingStatus status;

  Booking({
    required this.id,
    required this.vehicle,
    required this.pickupDate,
    required this.returnDate,
    required this.totalPrice,
    required this.status,
  });
}

class AppProvider with ChangeNotifier {
  AppProvider() {
    _initAuthListener();
    // Auto-fetch location on startup
    fetchCurrentLocation();
  }

  // Auth & Nav
  bool _isAuthenticated = false;
  int _currentTabIndex = 0;
  
  // Location
  String _currentLocation = 'Madhapur';
  String _currentCity = 'Hyderabad, Telangana';
  double _userLatitude = 17.4483;
  double _userLongitude = 78.3915;

  List<Booking> _bookings = [];
  UserProfile? _profile;
  User? _firebaseUser;

  List<String> _savedVehicleIds = ['1', '4'];
  
  Set<String> _selectedVehicleTypes = {};
  Set<String> _selectedFuelTypes = {};
  Set<String> _selectedCarCategories = {};
  Set<String> _selectedSeats = {};
  RangeValues _priceRange = const RangeValues(1000, 5000);
  DateTime? _pickupDate;
  DateTime? _returnDate;
  
  bool _isFetchingLocation = false;
  String _rentalDuration = '24_hours'; // '12_hours' or '24_hours'


  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      _firebaseUser = user;
      _isAuthenticated = user != null;
      if (user != null) {
        await _fetchUserProfile(user.uid);
      } else {
        _profile = null;
      }
      notifyListeners();
    });
  }

  Future<void> _fetchUserProfile(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        _profile = UserProfile.fromJson(doc.data()!, doc.id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching profile: \$e");
    }
  }

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  int get currentTabIndex => _currentTabIndex;
  String get currentLocation => _currentLocation;
  String get currentCity => _currentCity;
  double get userLatitude => _userLatitude;
  double get userLongitude => _userLongitude;
  List<Booking> get bookings => _bookings;
  UserProfile? get profile => _profile;
  List<String> get savedVehicleIds => _savedVehicleIds;
  
  Set<String> get selectedVehicleTypes => _selectedVehicleTypes;
  Set<String> get selectedFuelTypes => _selectedFuelTypes;
  Set<String> get selectedCarCategories => _selectedCarCategories;
  Set<String> get selectedSeats => _selectedSeats;
  RangeValues get priceRange => _priceRange;
  DateTime? get pickupDate => _pickupDate;
  DateTime? get returnDate => _returnDate;
  bool get isFetchingLocation => _isFetchingLocation;
  String get rentalDuration => _rentalDuration;

  // Booked Dates Map: Vehicle ID -> List of blocked DateTimeRanges
  final Map<String, List<DateTimeRange>> _blockedRanges = {};

  bool isTimeSlotAvailable(String vehicleId, DateTime proposedStart, DateTime proposedEnd) {
    if (!_blockedRanges.containsKey(vehicleId)) return true;

    for (var range in _blockedRanges[vehicleId]!) {
      // 6-hour buffer
      DateTime blockedStart = range.start.subtract(const Duration(hours: 6));
      DateTime blockedEnd = range.end.add(const Duration(hours: 6));

      // Overlap logic: A overlaps B if A.start < B.end AND A.end > B.start
      if (proposedStart.isBefore(blockedEnd) && proposedEnd.isAfter(blockedStart)) {
        return false;
      }
    }
    return true;
  }
  
  List<DateTimeRange> getBlockedRangesForVehicle(String vehicleId) {
    return _blockedRanges[vehicleId] ?? [];
  }

  void addBlockedDates(String vehicleId, DateTime start, DateTime end) {
    _blockedRanges.putIfAbsent(vehicleId, () => []);
    _blockedRanges[vehicleId]!.add(DateTimeRange(start: start, end: end));
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // The auth listener will automatically update state
    } catch (e) {
      debugPrint("Login error: \$e");
      rethrow; // Throw to handle in UI
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _currentTabIndex = 0;
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }
  
  void setLocation(String location, String city, {double? lat, double? lon, String? fullAddress}) async {
    _currentLocation = location;
    _currentCity = city;
    notifyListeners(); // Optimistic UI update
    
    if (lat != null && lon != null) {
      _userLatitude = lat;
      _userLongitude = lon;
      notifyListeners();
    } else if (fullAddress != null) {
      // Geocode the full address string using Google native geocoder
      try {
        List<geo.Location> locations = await geo.Geocoding().locationFromAddress(fullAddress);
        if (locations.isNotEmpty) {
          _userLatitude = locations.first.latitude;
          _userLongitude = locations.first.longitude;
          notifyListeners();
        }
      } catch (e) {
        debugPrint("Error geocoding address: \$e");
      }
    } else {
      // Fallback mocks
      if (location == 'Gachibowli') {
        _userLatitude = 17.4400;
        _userLongitude = 78.3489;
      } else if (location.contains('Airport')) {
        _userLatitude = 17.2403;
        _userLongitude = 78.4294;
      } else {
        _userLatitude = 17.4483; // Madhapur
        _userLongitude = 78.3915;
      }
      notifyListeners();
    }
  }

  Future<void> fetchCurrentLocation() async {
    _isFetchingLocation = true;
    notifyListeners();
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      } 

      Position position = await Geolocator.getCurrentPosition();
      _userLatitude = position.latitude;
      _userLongitude = position.longitude;

      List<geo.Placemark> placemarks = await geo.Geocoding().placemarkFromCoordinates(_userLatitude, _userLongitude);
      if (placemarks.isNotEmpty) {
        geo.Placemark place = placemarks[0];
        _currentLocation = place.subLocality?.isNotEmpty == true ? place.subLocality! : (place.locality ?? 'Current Location');
        _currentCity = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}'.trim().replaceAll(RegExp(r'^,\s*'), '');
      } else {
        _currentLocation = 'Current Location';
        _currentCity = 'Unknown City';
      }

    } catch (e) {
      debugPrint("Error fetching location: \$e");
    } finally {
      _isFetchingLocation = false;
      notifyListeners();
    }
  }

  void toggleSaved(String vehicleId) {
    if (_savedVehicleIds.contains(vehicleId)) {
      _savedVehicleIds.remove(vehicleId);
    } else {
      _savedVehicleIds.add(vehicleId);
    }
    notifyListeners();
  }

  bool isSaved(String vehicleId) => _savedVehicleIds.contains(vehicleId);

  // Bookings
  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  // Profile
  Future<void> updateProfile(UserProfile newProfile) async {
    _profile = newProfile;
    notifyListeners();
    if (_firebaseUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_firebaseUser!.uid)
            .set(newProfile.toJson(), SetOptions(merge: true));
      } catch (e) {
        debugPrint("Error updating profile in Firestore: \$e");
      }
    }
  }

  // Filters
  void toggleFilter(Set<String> filterSet, String value) {
    if (filterSet.contains(value)) {
      filterSet.remove(value);
    } else {
      filterSet.add(value);
    }
    notifyListeners(); // Actually filters might need to wait for 'Apply' but we can make it immediate or explicitly call apply. Let's make it immediate for simplicity, or we can use a local state in Modal. Let's just update provider.
  }
  
  void setPriceRange(RangeValues values) {
    _priceRange = values;
    notifyListeners();
  }
  
  void setDates(DateTime? start, DateTime? end) {
    _pickupDate = start;
    _returnDate = end;
    notifyListeners();
  }
  
  void setRentalDuration(String duration) {
    _rentalDuration = duration;
    notifyListeners();
  }

  void clearFilters() {
    _selectedVehicleTypes.clear();
    _selectedFuelTypes.clear();
    _selectedCarCategories.clear();
    _selectedSeats.clear();
    _priceRange = const RangeValues(1000, 5000);
    _pickupDate = null;
    _returnDate = null;
    notifyListeners();
  }

  // Filter Logic
  List<Vehicle> getFilteredVehicles(List<Vehicle> allVehicles, String activeCategory) {
    List<Vehicle> filtered = allVehicles.where((v) {
      // 1. Top Bar Category Filter
      if (activeCategory != 'all') {
        if (activeCategory == 'cars' && v.type != 'Car') return false;
        if (activeCategory == 'bikes' && v.type != 'Bike') return false;
        if (activeCategory == 'scooters' && v.type != 'Scooter') return false;
        if (activeCategory == 'suvs' && v.category != 'SUV') return false;
      }

      // 2. Modal Filters
      if (_selectedVehicleTypes.isNotEmpty && !_selectedVehicleTypes.contains(v.type)) return false;
      if (_selectedFuelTypes.isNotEmpty && !_selectedFuelTypes.contains(v.fuel)) return false;
      if (_selectedCarCategories.isNotEmpty && !_selectedCarCategories.contains(v.category)) return false;
      
      // Price
      if (v.pricePerDay < _priceRange.start || v.pricePerDay > _priceRange.end) return false;

      // Seats
      if (_selectedSeats.isNotEmpty) {
        String seatStr = '${v.seats}-seaters';
        if (v.type == 'Bike' || v.type == 'Scooter') seatStr = '2-seaters (Bike)';
        if (!_selectedSeats.contains(seatStr)) return false;
      }
      
      // Availability Dates
      if (_pickupDate != null && _returnDate != null) {
        if (!isTimeSlotAvailable(v.id, _pickupDate!, _returnDate!)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort dynamically based on user location
    filtered.sort((a, b) {
      final distA = math.pow(a.vendor.latitude - _userLatitude, 2) + math.pow(a.vendor.longitude - _userLongitude, 2);
      final distB = math.pow(b.vendor.latitude - _userLatitude, 2) + math.pow(b.vendor.longitude - _userLongitude, 2);
      return distA.compareTo(distB);
    });

    // Distance calculation and sorting could be done here if needed.
    // For now, map the vehicle and format distance from user location.
    return filtered.map((v) {
      if (_userLatitude != 0.0 && _userLongitude != 0.0) {
        double distInMeters = Geolocator.distanceBetween(
          _userLatitude,
          _userLongitude,
          v.vendor.latitude,
          v.vendor.longitude,
        );
        double distInKm = distInMeters / 1000;
        return v.copyWith(distance: '${distInKm.toStringAsFixed(1)} km');
      }
      return v;
    }).toList();
  }
}
