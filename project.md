# Project Memory Bank (.md)
This file serves as a persistent memory and version log for the entire development history of the RideNear (Car Rentals) App. It tracks every version, change, and prompt-driven implementation to maintain context.

## Maintenance Rules
1. Every time a change is made, a new version entry must be appended to the Version Log.
2. Every prompt that leads to a change must be summarized in the log.
3. The `.md` file must never be deleted or overwritten — only appended.

---

## Version Log

### Version 1.0 — [Initial Architecture & Base UI]
**Date**: September 13, 2026
**Prompt Given**: Initial creation of the Flutter Car Rentals App.
**Changes Made**: 
- Created base directory structure (`lib/features`, `lib/models`, `lib/providers`, `lib/shared`).
- Setup `AppProvider` for state management with mock data.
- Built UI for `ExploreScreen`, `VehicleDetailsScreen`, `BookingScreen`, `MapScreen`, `LoginScreen`, and `SignupScreen`.
- Designed `VehicleCard` for listings.
**Reason**: To establish the foundation, routing, and core UI for the rental marketplace.
**Outcome**: A functional static frontend with mock data.

### Version 1.1 — [Auth Fixes & Maps Polish]
**Date**: September 14, 2026
**Prompt Given**: Fix compilation errors in profile edit, add GPS recenter button in map, fix loading spinners in login.
**Changes Made**:
- `lib/features/profile/screens/edit_profile_screen.dart`: Imported `firebase_auth`.
- `lib/features/auth/screens/login_screen.dart`: Fixed `_isLoading` toggle to prevent spinner from disappearing too early.
- `lib/features/map/screens/map_screen.dart`: Added a FloatingActionButton that animates the camera back to the user's GPS coordinates.
- `lib/features/explore/screens/explore_screen.dart`: Added a "Clear" button to date filters and disabled `snap` on the SliverAppBar for smooth scrolling.
**Reason**: To fix compile errors, improve UX during authentication, and make the map view usable.
**Outcome**: Stable build with improved user experience on map and login screens.

### Version 1.2 — [Location API & Dual Pricing (12h/24h)]
**Date**: September 14, 2026
**Prompt Given**: Use real maps API (like Swiggy/Zomato) for location search. Implement 12-hour (30% discount) vs 24-hour pricing toggle.
**Changes Made**:
- `lib/features/explore/widgets/location_modal.dart`: Integrated Google Maps Places API for live location autocomplete (Later switched to OpenStreetMap/Nominatim in 1.3 due to API key restrictions).
- `lib/shared/widgets/vehicle_card.dart` & `VehicleDetailsScreen`: Updated to show both 12h (discounted) and 24h prices directly on the UI.
- `lib/features/booking/screens/booking_screen.dart`: Added dynamic base price logic. Fixed Review step math. Removed global 12/24 filter in favor of booking-time selection.
**Reason**: To provide a real-world location search experience and flexible pricing for short-term rentals.
**Outcome**: Users can search real cities and clearly see dual-pricing options before booking.

### Version 1.3 — [BookMyShow-Style Time Slots & 6-Hour Buffer]
**Date**: September 14, 2026
**Prompt Given**: Implement an interactive time-slot selector for duration (12 hours, 1 day to 10+ days). Add a 6-hour maintenance gap between bookings. Show exact math in review. Calculate actual distance. Fix auto-fetch GPS on load.
**Changes Made**:
- `lib/providers/app_provider.dart`: Changed `_bookedDates` to track exact `DateTimeRange`. Added a strict 6-hour buffer before and after all bookings. Added `Geolocator.distanceBetween` logic to calculate dynamic distance from user GPS to vendor. Added `fetchCurrentLocation()` to constructor for auto-fetch.
- `lib/features/booking/screens/booking_screen.dart`: Completely revamped Step 1 (Rental Details). Built a horizontally scrolling list of Durations (12h, 1-14 Days). Built a horizontally scrolling 30-day Calendar strip. Built a horizontally scrolling 24-hour Time Slot picker (00:00 to 23:00). Updated the Review step to explicitly show the math (e.g., `₹1800 × 4 Days`).
- `lib/features/explore/widgets/location_modal.dart`: Switched to Nominatim API to fix API key permission issues.
- `lib/shared/widgets/vehicle_card.dart`: Removed redundant "Details" button. Realigned pricing and "Book Now" buttons at the bottom.
**Reason**: To create a highly premium, collision-proof booking experience that dynamically blocks out unavailable times and respects vendor maintenance periods.
**Outcome**: A robust, mathematically sound booking engine with a beautiful scrollable UI and accurate distance calculations.

---

## Current Project State

### Tech Stack / Dependencies
- **SDK**: Flutter (Dart ^3.13.3)
- **State Management**: Provider (`^6.1.5+1`)
- **Backend/Services**: Firebase Core, Auth, Cloud Firestore, Firebase Storage
- **Location/Maps**: Google Maps Flutter, Geolocator, Geocoding, HTTP (Nominatim)
- **UI/Icons**: Google Fonts, Lucide Icons, Cupertino Icons

### Core Features Implemented
- Authentication (Email/Password Login & Signup UI).
- Real-time GPS Location Fetching & Nominatim Place Search.
- Dynamic Haversine Distance Calculation.
- Vehicle Listing & Filtering (Categories, Prices, Seats, Transmission, Fuel).
- Interactive Booking Engine:
  - 14-Day Duration Scroll.
  - 30-Day Calendar Strip.
  - 24-Hour Time Slot Scroll.
  - Exact `DateTimeRange` overlap prevention with a strict 6-hour maintenance buffer.
- Multi-step Booking Form (Rental Details, KYC, Review, Payment).
- Dual Pricing UI (12-Hour discounted vs Daily rate).

### Key Files
- `lib/main.dart`: Entry point.
- `lib/providers/app_provider.dart`: Global state, overlapping logic, distances.
- `lib/models/vehicle.dart`, `user_profile.dart`, `booking.dart`: Core data models.
- `lib/features/explore/screens/explore_screen.dart`: Home listing view.
- `lib/features/explore/widgets/location_modal.dart`: Nominatim API search.
- `lib/shared/widgets/vehicle_card.dart`: Reusable listing card.
- `lib/features/booking/screens/booking_screen.dart`: The core booking stepper.
- `lib/features/map/screens/map_screen.dart`: Google Maps integration.

### Known Issues / Pending Work
- **Firebase Sync**: Bookings are currently stored in `AppProvider`'s temporary memory (`_blockedRanges`). Doing a Hot Restart wipes out booked slots. The next major step is to persist bookings, users, and vehicles into Cloud Firestore.
- **Payment Gateway**: The "Pay & Confirm" button does not currently trigger Razorpay/Stripe; it only creates the booking in memory.
- **Profile Image Picker**: The Profile screen needs integration with `image_picker` and `firebase_storage` to allow users to update their avatar.
- **Google Sign-In**: "Continue with Google" button is currently a placeholder.
