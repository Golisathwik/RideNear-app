import { Star, Heart, MapPin, CheckCircle2 } from "lucide-react"

export interface Vehicle {
  id: string
  name: string
  image: string
  category: string
  vendor: {
    name: string
    verified: boolean
    rating: number
    reviews: number
  }
  distance: string
  pricePerDay: number
  pricePerHour: number
  transmission: string
  fuel: string
  seats?: number
  available: boolean
}

interface VehicleCardProps {
  vehicle: Vehicle
  isSaved?: boolean
  onBook: (id: string) => void
  onDetails: (id: string) => void
  onToggleSave?: (id: string) => void
}

export default function VehicleCard({
  vehicle,
  isSaved = false,
  onBook,
  onDetails,
  onToggleSave,
}: VehicleCardProps) {
  return (
    <div className="bg-card rounded-2xl border border-border overflow-hidden shadow-sm flex flex-col mb-4">
      <div className="relative h-48 w-full bg-accent">
        <img
          src={vehicle.image}
          alt={vehicle.name}
          className="w-full h-full object-cover"
        />
        <div className="absolute top-3 left-3 flex flex-col gap-2">
          {vehicle.available ? (
            <span className="bg-success text-white px-2 py-1 rounded-full text-xs font-medium">
              Available
            </span>
          ) : (
            <span className="bg-warning text-white px-2 py-1 rounded-full text-xs font-medium">
              Limited
            </span>
          )}
        </div>
        <button
          onClick={(e) => {
            e.stopPropagation()
            onToggleSave?.(vehicle.id)
          }}
          className="absolute top-3 right-3 p-2 bg-white/80 backdrop-blur-md rounded-full text-foreground hover:text-secondary transition-colors"
        >
          <Heart
            className={`w-5 h-5 ${
              isSaved ? "fill-secondary text-secondary" : ""
            }`}
          />
        </button>
      </div>

      <div className="p-4 flex flex-col gap-3">
        <div className="flex justify-between items-start">
          <div>
            <div className="flex items-center gap-2 mb-1">
              <span className="text-xs font-medium text-secondary">
                {vehicle.category}
              </span>
            </div>
            <h3 className="text-lg font-bold text-foreground leading-tight">
              {vehicle.name}
            </h3>
          </div>
          <div className="text-right">
            <div className="text-lg font-bold text-primary">
              ₹{vehicle.pricePerDay}
            </div>
            <div className="text-xs text-foreground/60">per day</div>
          </div>
        </div>

        <div className="flex items-center gap-1.5 text-xs text-foreground/80 font-medium">
          <span className="flex items-center gap-1">
            <Star className="w-3.5 h-3.5 fill-warning text-warning" />{" "}
            {vehicle.vendor.rating}
          </span>
          <span className="text-foreground/40">•</span>
          <span className="flex items-center gap-1">
            {vehicle.vendor.name}{" "}
            {vehicle.vendor.verified && (
              <CheckCircle2 className="w-3.5 h-3.5 text-secondary" />
            )}
          </span>
          <span className="text-foreground/40">•</span>
          <span className="flex items-center gap-1 text-foreground/60">
            <MapPin className="w-3.5 h-3.5" /> {vehicle.distance}
          </span>
        </div>

        <div className="flex gap-2 text-xs text-foreground/70 bg-accent rounded-lg p-2.5">
          <div className="flex-1 text-center border-r border-border/50">
            {vehicle.transmission}
          </div>
          <div className="flex-1 text-center border-r border-border/50">
            {vehicle.fuel}
          </div>
          <div className="flex-1 text-center">
            {vehicle.seats ? `${vehicle.seats} Seats` : "2 Seats"}
          </div>
        </div>

        <div className="flex gap-2 mt-1">
          <button
            onClick={() => onDetails(vehicle.id)}
            className="flex-1 py-3 px-4 rounded-xl border border-primary text-primary font-semibold text-sm hover:bg-primary/5 transition-colors"
          >
            Details
          </button>
          <button
            onClick={() => onBook(vehicle.id)}
            className="flex-1 py-3 px-4 rounded-xl bg-primary text-primary-foreground font-semibold text-sm hover:bg-primary/90 transition-colors"
          >
            Book Now
          </button>
        </div>
      </div>
    </div>
  )
}
