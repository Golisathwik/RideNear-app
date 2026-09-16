# Figma AI Design Prompt — Vehicle Rental Aggregator Customer App

Design a modern, premium, user-friendly **mobile application UI/UX for a vehicle rental booking platform** called **RideNear**. The platform connects users with verified local rental vendors, allowing them to discover, compare, and book nearby cars and bikes.

The main goal of the app is to make finding nearby rental vehicles fast and convenient. Users should be able to view available rental vehicles in beautiful cards, explore verified rental vendors on an interactive map, filter vehicles based on their preferences, and complete advance bookings through a transparent checkout process.

Create a complete, high-fidelity, production-ready mobile app design in Figma. Focus on clean layouts, intuitive navigation, modern visual design, and a seamless booking experience.

---

## 1. Design Style and Visual Identity

* Platform name: RideNear
* App type: Vehicle rental aggregator and booking platform
* Target users: Students, tourists, travelers, working professionals, and people looking for short-term car or bike rentals.
* Design style: Modern, premium, clean, trustworthy, and technology-driven.
* Color palette:

  * Primary: Deep navy or dark blue.
  * Secondary: Bright blue or teal for interactive elements.
  * Background: White and light gray.
  * Accent: Green for available vehicles and successful bookings.
  * Warning: Orange for limited availability.
* Use a consistent 8-point spacing system.
* Use rounded cards with 16–20px corner radius.
* Use subtle shadows, clean borders, and proper visual hierarchy.
* Use modern typography such as Inter, Manrope, or SF Pro.
* Use high-quality vehicle photography with consistent image proportions.
* Use realistic icons for cars, bikes, location, calendar, filters, fuel, transmission, price, and navigation.
* Use accessible contrast, readable text, and large touch-friendly buttons.
* Create reusable Figma components, variants, auto-layout frames, and a consistent design system.

---

## 2. App Navigation

Create a bottom navigation bar with four primary sections:

1. **Explore** — Discover nearby rental vehicles and vendors.
2. **Bookings** — View upcoming, active, completed, and cancelled bookings.
3. **Saved** — View favorite vehicles and vendors.
4. **Profile** — Manage personal details, KYC, payments, and settings.

Include a prominent location selector at the top of the Explore screen.

---

## 3. Screen 1 — Welcome and Onboarding

Design a visually appealing onboarding experience.

Include:

* App logo and RideNear branding.
* Hero image showing a rented car and bike.
* Headline: **“Find your perfect ride, near you.”**
* Supporting text: “Discover verified rental vendors and book cars or bikes with ease.”
* Primary button: **Get Started**
* Secondary option: **Log In**
* Three onboarding slides:

  1. Discover nearby cars and bikes.
  2. Compare rental prices and availability.
  3. Book securely with transparent pricing.

Use minimal, premium illustrations or high-quality vehicle imagery.

---

## 4. Screen 2 — Login and Signup

Create clean authentication screens.

### Login

* Mobile number or email input.
* Password input if using email authentication.
* Continue button.
* OTP login option.
* Google Sign-In button.
* Forgot password option.
* Link to Create Account.

### Signup

* Full name.
* Mobile number.
* Email address.
* Password.
* Confirm password.
* Terms and conditions checkbox.
* Create Account button.

Design an OTP verification screen with six-digit input fields and a resend timer.

---

## 5. Screen 3 — Explore / Home Dashboard

This is the primary screen of the app and should have the strongest visual design.

### Header

* Greeting: “Where do you want to go?”
* User profile avatar.
* Notification icon.
* Location selector with GPS icon.
* Example location: “Madhapur, Hyderabad”
* Option to change location.

### Search Section

Create a prominent search bar:

**“Search cars, bikes, or rental vendors”**

Include:

* Search icon.
* Voice search icon.
* Search by vehicle name, vendor name, or location.
* Recent searches.

### Rental Category Selector

Create attractive category cards or horizontal chips:

* All
* Cars
* Bikes
* Scooters
* Cruisers
* Hatchbacks
* Sedans
* SUVs

Each category should have a relevant icon or vehicle image.

### Booking Preferences

Add a compact search and booking panel containing:

* Pickup location.
* Pickup date and time.
* Return date and time.
* Vehicle type.
* Search Vehicles button.

### Nearby Available Vehicles

Display the heading:

**“Available near you”**

Show vehicle cards in a clean, responsive layout. On mobile, use a vertical list with optional horizontal carousels for featured sections.

Each vehicle card must include:

* Large, high-quality vehicle image.
* Vehicle name, such as “Honda Activa 6G” or “Hyundai i20”.
* Vehicle category, such as Scooter, Hatchback, or SUV.
* Vendor name and verified badge.
* Vendor rating and review count.
* Distance from the user's location.
* Price per hour and/or per day.
* Availability status.
* Transmission type.
* Fuel type.
* Seating capacity for cars.
* Favorite heart button.
* **View Details** or **Book Now** button.

Example card:

**Hyundai i20**

Verified vendor · 4.8 ★

1.8 km away

₹1,800/day · ₹250/hour

Manual · Petrol · 5 Seats

[View Details] [Book Now]

Use realistic sample data and clearly distinguish available, booked, and unavailable vehicles.

### Additional Home Sections

Include:

* Featured rental vendors.
* Popular cars near you.
* Popular bikes near you.
* Best-rated vendors.
* Budget-friendly rentals.
* Recently viewed vehicles.
* Promotional banner for first-time users.

---

## 6. Screen 4 — Explore Map View

Create a dedicated interactive map-based vehicle discovery screen.

The map is a major feature of the application.

### Map Requirements

* Full-screen Google Maps-style interface.
* Display the user's current location.
* Show verified rental vendor locations using map markers.
* Show available vehicles associated with each vendor.
* Use distinct marker styles for car rental hubs and bike rental hubs.
* Display vehicle availability counts near vendor markers.
* Use map clustering when multiple vendors are close together.
* Provide zoom in, zoom out, current location, and map/list toggle controls.
* Show a search area button such as **“Search this area.”**
* Show a radius or nearby search option.
* Do not display unverified vendors.
* Use a clean map theme with readable roads and location markers.

### Map Interaction

When a user taps a vendor marker, display a bottom sheet containing:

* Vendor name.
* Verified badge.
* Vendor rating.
* Distance.
* Number of available cars and bikes.
* Starting rental price.
* Preview of available vehicles.
* **View Vehicles** button.

When a user selects a vehicle from the bottom sheet, open the vehicle details page.

Add a floating button to switch between:

* **Map View**
* **List View**

The map should make it easy for users to understand where the rental vendors and available vehicles are located.

---

## 7. Screen 5 — Search Results and Vehicle Listing

Design a search results screen that displays nearby available cars and bikes.

Include:

* Search location.
* Pickup and return dates.
* Number of results.
* Map/List toggle.
* Sort button.
* Filter button.
* Search bar.
* Vertical vehicle cards.

### Filters

Create a filter bottom sheet or full-screen filter page with:

* Vehicle type: Car, Bike, Scooter, Cruiser, Hatchback, Sedan, SUV.
* Price range slider.
* Distance from pickup location.
* Transmission: Manual or Automatic.
* Fuel type: Petrol, Diesel, Electric, CNG.
* Seating capacity.
* Vendor rating.
* Available now.
* Vendor verification.
* Pickup and return date/time.

Add **Clear All** and **Apply Filters** buttons.

### Sort Options

* Recommended.
* Price: Low to High.
* Price: High to Low.
* Nearest First.
* Highest Rated.
* Most Popular.

Ensure the listing cards update visually based on the selected filters and sorting options.

---

## 8. Screen 6 — Vehicle Details Page

Design a detailed vehicle information screen.

Include:

* Large vehicle image gallery.
* Image carousel with multiple vehicle photos.
* Vehicle name and category.
* Verified rental vendor information.
* Rating and reviews.
* Distance from the user.
* Availability status.
* Rental price per hour and per day.
* Refundable security deposit.
* Vehicle specifications:

  * Brand and model.
  * Vehicle type.
  * Fuel type.
  * Transmission.
  * Seating capacity.
  * Model year.
  * Mileage or range where relevant.
* Rental terms and conditions.
* Pickup and return location.
* Vendor contact or messaging option.
* Customer reviews.
* Favorite button.
* **Check Availability** button.
* **Book Now** button.

Show clear pricing and avoid hiding additional charges.

---

## 9. Screen 7 — Booking Flow

Create a smooth multi-step booking experience.

### Step 1: Select Rental Details

* Pickup location.
* Return location.
* Pickup date and time.
* Return date and time.
* Rental duration.
* Selected vehicle summary.

### Step 2: Customer Verification / KYC

Create a digital KYC screen containing:

* Full name.
* Date of birth.
* Driving license upload.
* Driving license number.
* License expiry date.
* Upload front and back of license.
* OCR verification status.
* Verification progress indicator.

Use clear privacy and security messaging.

### Step 3: Review Booking

Display:

* Vehicle details.
* Vendor details.
* Pickup and return details.
* Rental duration.
* Base rental cost.
* Refundable security deposit.
* Platform fee.
* Taxes.
* Discounts.
* Total payable amount.
* Cancellation policy.

### Step 4: Payment

Include:

* UPI.
* Debit or credit card.
* Net banking.
* Saved payment methods.
* Secure payment messaging.
* Pay Now button.

### Step 5: Booking Confirmation

Create a successful booking screen with:

* Success illustration.
* Booking ID.
* Vehicle details.
* Vendor name.
* Pickup location.
* Pickup and return date/time.
* Total amount.
* QR code or booking reference.
* View Booking button.
* Get Directions button.
* Download or share receipt option.

---

## 10. Screen 8 — My Bookings

Design a booking management screen with tabs:

* Upcoming.
* Active.
* Completed.
* Cancelled.

Each booking card should display:

* Vehicle image.
* Vehicle name.
* Vendor name.
* Booking ID.
* Rental dates.
* Pickup location.
* Booking status.
* Total amount.
* View Details button.
* Cancel Booking button when eligible.

Create detailed booking status screens with pickup instructions, vendor information, payment details, and cancellation policies.

---

## 11. Screen 9 — Saved Vehicles and Vendors

Design a favorites screen where users can save:

* Favorite cars.
* Favorite bikes.
* Favorite vendors.

Each saved vehicle card should have:

* Vehicle image.
* Vehicle name.
* Vendor name.
* Price.
* Rating.
* Availability status.
* Remove from favorites button.
* Book Now button.

---

## 12. Screen 10 — User Profile and Settings

Include:

* Profile photo.
* User name.
* Email and phone number.
* Edit profile.
* KYC verification status.
* My documents.
* Saved payment methods.
* Booking history.
* Notifications.
* Help and support.
* Terms and conditions.
* Privacy policy.
* Language selection.
* Logout.

Create a clean and organized settings interface.

---

## 13. Important UX Requirements

* Prioritize nearby vehicle discovery.
* Make the map and list views work together.
* Show only officially onboarded and verified rental vendors.
* Make vehicle availability easy to understand.
* Clearly distinguish cars from bikes.
* Provide accurate-looking location, pricing, and availability states using realistic sample data.
* Make booking dates and times easy to select.
* Show transparent pricing before payment.
* Design empty states for:

  * No vehicles found.
  * No vendors nearby.
  * No search results for selected filters.
  * No upcoming bookings.
  * Location permission denied.
* Design loading skeletons for vehicle cards and map data.
* Design error states for payment failures, KYC failures, and unavailable vehicles.
* Include confirmation dialogs for cancellation and logout.
* Use bottom sheets for filters, vendor previews, and quick actions.
* Ensure the interface is optimized for one-handed mobile use.
* Maintain a consistent component system across all screens.

---

## 14. Figma Deliverables

Create the following organized Figma pages:

1. **Design System** — Colors, typography, icons, buttons, inputs, cards, badges, bottom sheets, and navigation components.
2. **Onboarding & Authentication**
3. **Explore / Home**
4. **Map Discovery**
5. **Search & Filters**
6. **Vehicle Details**
7. **Booking & Checkout**
8. **Bookings**
9. **Saved**
10. **Profile & Settings**
11. **Prototype Flow**

Create reusable components with variants for:

* Available, booked, and unavailable vehicle cards.
* Car and bike cards.
* Map markers.
* Verified and unverified status badges.
* Buttons and input fields.
* Booking status badges.
* Bottom navigation.
* Filter chips.
* Vendor cards.

Connect the main screens with a clickable prototype demonstrating this user journey:

**Open App → Select Location → Explore Nearby Vehicles → Switch to Map View → Select Vendor → View Vehicle → Apply Filters → Select Dates → Complete KYC → Review Price → Make Payment → Booking Confirmation → My Bookings.**

The final design should feel like a professional, trustworthy, modern rental marketplace application, combining the ease of a food delivery discovery app with the booking experience of a premium travel and mobility platform. Avoid overcrowded screens, excessive colors, generic templates, and unnecessary features. Focus on a polished and intuitive customer experience.
