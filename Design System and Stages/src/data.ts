import { Vehicle } from "./components/VehicleCard"

export const CATEGORIES = [
  { id: 'all', label: 'All' },
  { id: 'cars', label: 'Cars' },
  { id: 'bikes', label: 'Bikes' },
  { id: 'scooters', label: 'Scooters' },
  { id: 'suvs', label: 'SUVs' },
];

export const SAMPLE_VEHICLES: Vehicle[] = [
  {
    id: "1",
    name: "Hyundai i20",
    category: "Hatchback",
    image:
      "https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=600&q=80",
    vendor: {
      name: "DriveJoy Rentals",
      verified: true,
      rating: 4.8,
      reviews: 124,
    },
    distance: "1.8 km",
    pricePerDay: 1800,
    pricePerHour: 250,
    transmission: "Manual",
    fuel: "Petrol",
    seats: 5,
    available: true,
  },
  {
    id: "2",
    name: "Royal Enfield Classic",
    category: "Cruiser",
    image:
      "https://images.unsplash.com/photo-1558981403-c5f9899a28bc?auto=format&fit=crop&w=600&q=80",
    vendor: { name: "MotoRides", verified: true, rating: 4.9, reviews: 312 },
    distance: "2.4 km",
    pricePerDay: 1200,
    pricePerHour: 150,
    transmission: "Manual",
    fuel: "Petrol",
    available: true,
  },
  {
    id: "3",
    name: "Honda Activa 6G",
    category: "Scooter",
    image:
      "https://images.unsplash.com/photo-1625232230846-9d32b36e84d9?auto=format&fit=crop&w=600&q=80",
    vendor: { name: "City Scoots", verified: true, rating: 4.6, reviews: 89 },
    distance: "0.8 km",
    pricePerDay: 500,
    pricePerHour: 50,
    transmission: "Auto",
    fuel: "Petrol",
    available: false,
  },
]
