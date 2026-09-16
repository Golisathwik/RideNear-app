import { Heart, Search } from "lucide-react"
import VehicleCard from "../components/VehicleCard"
import { SAMPLE_VEHICLES } from "../data"

interface SavedScreenProps {
  savedIds: string[]
  onToggleSave: (id: string) => void
}

export default function SavedScreen({
  savedIds,
  onToggleSave,
}: SavedScreenProps) {
  const savedVehicles = SAMPLE_VEHICLES.filter((v) => savedIds.includes(v.id))

  return (
    <div className="min-h-screen bg-background pb-24">
      <div className="bg-card px-4 pt-safe-top pb-4 border-b border-border sticky top-0 z-40">
        <h1 className="text-2xl font-bold mt-2">Saved Vehicles</h1>
      </div>

      <div className="p-4">
        {savedVehicles.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-[60vh] text-center px-4">
            <div className="w-16 h-16 bg-accent rounded-full flex items-center justify-center mb-4">
              <Heart className="w-8 h-8 text-foreground/30" />
            </div>
            <h2 className="text-xl font-bold mb-2">No saved vehicles yet</h2>
            <p className="text-foreground/60">
              Tap the heart icon on any vehicle to save it here for later.
            </p>
          </div>
        ) : (
          <div className="flex flex-col gap-4">
            {savedVehicles.map((vehicle) => (
              <VehicleCard
                key={vehicle.id}
                vehicle={vehicle}
                isSaved={true}
                onBook={(id) => console.log("book", id)}
                onDetails={(id) => console.log("details", id)}
                onToggleSave={onToggleSave}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
