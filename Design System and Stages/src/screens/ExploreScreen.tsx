import { useState } from "react"
import {
  Search,
  MapPin,
  Bell,
  Mic,
  Map as MapIcon,
  ListFilter,
  List,
  ChevronLeft,
  Star,
  ShieldCheck,
  ChevronDown,
} from "lucide-react"
import VehicleCard, { Vehicle } from "../components/VehicleCard"
import FilterModal from "../components/FilterModal"
import LocationModal from "../components/LocationModal"
import { SAMPLE_VEHICLES, CATEGORIES } from "../data"

interface ExploreScreenProps {
  savedIds: string[]
  onToggleSave: (id: string) => void
}

export default function ExploreScreen({
  savedIds,
  onToggleSave,
}: ExploreScreenProps) {
  const [activeCategory, setActiveCategory] = useState("all")
  const [viewMode, setViewMode] = useState<"list" | "map">("list")
  const [isFilterOpen, setIsFilterOpen] = useState(false)
  const [isLocationOpen, setIsLocationOpen] = useState(false)
  const [selectedMapVehicle, setSelectedMapVehicle] = useState<Vehicle | null>(
    null,
  )
  const [detailsVehicle, setDetailsVehicle] = useState<Vehicle | null>(null)

  const mapPositions = [
    { top: "35%", left: "25%" },
    { top: "65%", left: "60%" },
    { top: "45%", left: "75%" },
  ]

  if (detailsVehicle) {
    return (
      <div className="fixed inset-0 z-50 bg-background overflow-y-auto animate-in fade-in duration-300">
        <div className="relative h-72">
          <img
            src={detailsVehicle.image}
            alt={detailsVehicle.name}
            className="w-full h-full object-cover"
          />
          <button
            onClick={() => setDetailsVehicle(null)}
            className="absolute top-safe-top left-4 p-2 bg-white/80 backdrop-blur-md rounded-full mt-4"
          >
            <ChevronLeft className="w-6 h-6 text-foreground" />
          </button>
        </div>
        <div className="p-4">
          <div className="flex justify-between items-start mb-4">
            <div>
              <span className="text-secondary font-bold text-sm">
                {detailsVehicle.category}
              </span>
              <h1 className="text-2xl font-bold text-foreground">
                {detailsVehicle.name}
              </h1>
            </div>
            <div className="text-right">
              <div className="text-2xl font-bold text-primary">
                ₹{detailsVehicle.pricePerDay}
              </div>
              <div className="text-sm text-foreground/60">per day</div>
            </div>
          </div>

          <div className="flex gap-4 p-4 bg-accent rounded-2xl mb-6">
            <div className="flex-1 text-center border-r border-border">
              <div className="text-xs text-foreground/60 mb-1">
                Transmission
              </div>
              <div className="font-bold text-sm">
                {detailsVehicle.transmission}
              </div>
            </div>
            <div className="flex-1 text-center border-r border-border">
              <div className="text-xs text-foreground/60 mb-1">Fuel</div>
              <div className="font-bold text-sm">{detailsVehicle.fuel}</div>
            </div>
            <div className="flex-1 text-center">
              <div className="text-xs text-foreground/60 mb-1">Seats</div>
              <div className="font-bold text-sm">
                {detailsVehicle.seats || 2}
              </div>
            </div>
          </div>

          <div className="mb-6">
            <h3 className="font-bold text-lg mb-3">Vendor Details</h3>
            <div className="flex items-center gap-3 p-4 border border-border rounded-2xl">
              <div className="w-12 h-12 bg-secondary/10 rounded-full flex items-center justify-center text-secondary">
                <ShieldCheck className="w-6 h-6" />
              </div>
              <div className="flex-1">
                <div className="font-bold text-foreground flex items-center gap-1">
                  {detailsVehicle.vendor.name}
                  {detailsVehicle.vendor.verified && (
                    <ShieldCheck className="w-4 h-4 text-secondary" />
                  )}
                </div>
                <div className="text-sm text-foreground/60 flex items-center gap-1">
                  <Star className="w-4 h-4 text-warning fill-warning" />{" "}
                  {detailsVehicle.vendor.rating} (
                  {detailsVehicle.vendor.reviews} reviews)
                </div>
              </div>
              <button className="flex flex-col items-center justify-center gap-1 px-3 py-2 bg-accent rounded-xl text-primary hover:bg-accent/80 transition-colors">
                <MapPin className="w-5 h-5" />
                <span className="text-[10px] font-bold">Directions</span>
              </button>
            </div>
          </div>

          <button className="w-full bg-primary text-primary-foreground py-4 rounded-xl font-bold text-lg hover:bg-primary/90 transition-colors">
            Proceed to Book
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header */}
      <div className="bg-card px-4 pt-safe-top pb-4 border-b border-border sticky top-0 z-40 shadow-sm">
        <div className="flex justify-between items-center mb-5 mt-2">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center">
              <MapPin className="w-5 h-5 text-primary" />
            </div>
            <div className="cursor-pointer" onClick={() => setIsLocationOpen(true)}>
              <div className="flex items-center gap-1">
                <span className="font-bold text-lg text-foreground">
                  Madhapur
                </span>
                <ChevronDown className="w-5 h-5 text-foreground" />
              </div>
              <p className="text-xs text-foreground/60 font-medium truncate w-48">
                Hyderabad, Telangana
              </p>
            </div>
          </div>
          <button className="relative p-2 text-foreground">
            <Bell className="w-6 h-6" />
            <span className="absolute top-2 right-2 w-2 h-2 bg-warning rounded-full border-2 border-card"></span>
          </button>
        </div>

        {/* Search */}
        <div className="flex gap-3">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-foreground/40" />
            <input
              type="text"
              placeholder="Search cars, bikes, or vendors"
              className="w-full bg-accent border border-border/50 rounded-xl py-3 pl-10 pr-10 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 placeholder:text-foreground/40 font-medium shadow-sm"
            />
            <Mic className="absolute right-3 top-1/2 -translate-y-1/2 w-5 h-5 text-foreground/40" />
          </div>
          <button
            onClick={() => setIsFilterOpen(true)}
            className="p-3 bg-card border border-border text-foreground rounded-xl flex items-center justify-center shadow-sm hover:bg-accent transition-colors"
          >
            <ListFilter className="w-5 h-5" />
          </button>
        </div>
      </div>

      <div className="p-4">
        {/* Categories */}
        <div className="flex gap-3 overflow-x-auto pb-4 scrollbar-none -mx-4 px-4">
          {CATEGORIES.map((cat) => (
            <button
              key={cat.id}
              onClick={() => setActiveCategory(cat.id)}
              className={`px-5 py-2.5 rounded-full whitespace-nowrap text-sm font-semibold transition-colors ${
                activeCategory === cat.id
                  ? "bg-primary text-primary-foreground"
                  : "bg-card border border-border text-foreground hover:bg-accent"
              }`}
            >
              {cat.label}
            </button>
          ))}
        </div>

        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-bold">Available near you</h2>
        </div>

        {viewMode === "list" ? (
          <div className="flex flex-col gap-4">
            {SAMPLE_VEHICLES.map((vehicle) => (
              <VehicleCard
                key={vehicle.id}
                vehicle={vehicle}
                isSaved={savedIds.includes(vehicle.id)}
                onBook={(id) => console.log("book", id)}
                onDetails={(id) =>
                  setDetailsVehicle(
                    SAMPLE_VEHICLES.find((v) => v.id === id) || null,
                  )
                }
                onToggleSave={onToggleSave}
              />
            ))}
          </div>
        ) : (
          <div className="relative h-[65vh] bg-[#e5e7eb] rounded-3xl border border-border overflow-hidden">
            {/* Simulated Map Background grid */}
            <div
              className="absolute inset-0"
              style={{
                backgroundImage:
                  "radial-gradient(#cbd5e1 2px, transparent 2px)",
                backgroundSize: "32px 32px",
              }}
            />

            {/* Radar Dots */}
            {SAMPLE_VEHICLES.map((vehicle, idx) => (
              <div
                key={vehicle.id}
                onClick={() => setSelectedMapVehicle(vehicle)}
                className="absolute w-5 h-5 bg-secondary rounded-full cursor-pointer shadow-[0_0_0_6px_rgba(14,165,233,0.3)] animate-pulse transition-transform hover:scale-110 z-10"
                style={mapPositions[idx]}
              />
            ))}

            {/* Bottom Sheet for Map Vehicle */}
            {selectedMapVehicle && (
              <div className="absolute inset-x-0 bottom-0 bg-background rounded-t-3xl p-4 shadow-[0_-8px_30px_rgba(0,0,0,0.15)] animate-in slide-in-from-bottom-full duration-300 z-20">
                <div
                  className="w-12 h-1.5 bg-border rounded-full mx-auto mb-4 cursor-pointer"
                  onClick={() => setSelectedMapVehicle(null)}
                />
                <VehicleCard
                  vehicle={selectedMapVehicle}
                  isSaved={savedIds.includes(selectedMapVehicle.id)}
                  onBook={(id) => console.log("book", id)}
                  onDetails={(id) =>
                    setDetailsVehicle(
                      SAMPLE_VEHICLES.find((v) => v.id === id) || null,
                    )
                  }
                  onToggleSave={onToggleSave}
                />
              </div>
            )}
          </div>
        )}
      </div>

      {/* Floating Toggle */}
      <div className="fixed bottom-24 left-1/2 -translate-x-1/2 z-40">
        <button
          onClick={() => setViewMode(viewMode === "list" ? "map" : "list")}
          className="bg-foreground text-background px-6 py-3 rounded-full flex items-center gap-2 font-semibold shadow-lg hover:scale-105 transition-transform"
        >
          {viewMode === "list" ? (
            <>
              <MapIcon className="w-5 h-5" /> Map View
            </>
          ) : (
            <>
              <List className="w-5 h-5" /> List View
            </>
          )}
        </button>
      </div>

      <FilterModal
        isOpen={isFilterOpen}
        onClose={() => setIsFilterOpen(false)}
      />
      
      <LocationModal
        isOpen={isLocationOpen}
        onClose={() => setIsLocationOpen(false)}
      />
    </div>
  )
}
