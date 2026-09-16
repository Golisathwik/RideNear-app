import { useState } from "react"
import { X, Check } from "lucide-react"

interface FilterModalProps {
  isOpen: boolean
  onClose: () => void
}

export default function FilterModal({ isOpen, onClose }: FilterModalProps) {
  const [activeTab, setActiveTab] = useState("Dates")
  const [selectedFilters, setSelectedFilters] =
    useState<Record<string, string[]>>({
      "Vehicle Type": [],
      "Car Categories": [],
      "Price Range": [],
      Seating: [],
    })

  if (!isOpen) return null

  const tabs = [
    "Dates",
    "Vehicle Type",
    "Fuel Type",
    "Car Categories",
    "Price Range",
    "Seating",
  ]

  const filterOptions: Record<string, string[]> = {
    "Vehicle Type": ["Cars", "Bikes", "Scooters"],
    "Fuel Type": ["Petrol", "Diesel", "EV"],
    "Car Categories": [
      "SUV",
      "XUV",
      "Premium Cars",
      "Sedan",
      "Hatchback",
      "Cruiser",
    ],
    "Price Range": [
      "Under ₹1,000/day",
      "₹1,000 - ₹3,000/day",
      "₹3,000 - ₹5,000/day",
      "Over ₹5,000/day",
    ],
    Seating: ["2 Seater", "4 Seater", "5 Seater", "7 Seater", "8+ Seater"],
  }

  const toggleFilter = (category: string, option: string) => {
    setSelectedFilters((prev) => {
      const current = prev[category] || []
      const updated = current.includes(option)
        ? current.filter((item) => item !== option)
        : [...current, option]
      return { ...prev, [category]: updated }
    })
  }

  const renderContent = () => {
    if (activeTab === "Dates") {
      return (
        <div className="p-4 space-y-4">
          <div>
            <label className="block text-xs font-bold text-foreground/60 uppercase tracking-wider mb-2">
              Pickup Date & Time
            </label>
            <input
              type="datetime-local"
              className="w-full bg-accent border border-border rounded-xl p-3 text-sm focus:ring-2 focus:ring-secondary/50 outline-none"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-foreground/60 uppercase tracking-wider mb-2">
              Return Date & Time
            </label>
            <input
              type="datetime-local"
              className="w-full bg-accent border border-border rounded-xl p-3 text-sm focus:ring-2 focus:ring-secondary/50 outline-none"
            />
          </div>
        </div>
      )
    }

    const options = filterOptions[activeTab]
    if (!options) return null

    return (
      <div className="p-0">
        {options.map((option) => {
          const isSelected = selectedFilters[activeTab]?.includes(option)
          return (
            <button
              key={option}
              onClick={() => toggleFilter(activeTab, option)}
              className="w-full flex items-center justify-between p-4 border-b border-border/50 text-left hover:bg-accent/50 transition-colors"
            >
              <span
                className={`text-sm ${
                  isSelected
                    ? "font-bold text-primary"
                    : "font-medium text-foreground/80"
                }`}
              >
                {option}
              </span>
              <div
                className={`w-5 h-5 rounded-md border flex items-center justify-center transition-colors ${
                  isSelected
                    ? "bg-secondary border-secondary text-white"
                    : "border-foreground/30 bg-card"
                }`}
              >
                {isSelected && (
                  <Check className="w-3.5 h-3.5" strokeWidth={3} />
                )}
              </div>
            </button>
          )
        })}
      </div>
    )
  }

  const getSelectedCount = (tab: string) => {
    return selectedFilters[tab]?.length || 0
  }

  const totalSelections = Object.values(selectedFilters).reduce(
    (acc, curr) => acc + curr.length,
    0,
  )

  return (
    <div className="fixed inset-0 z-50 flex flex-col bg-background animate-in slide-in-from-bottom-full duration-300">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-4 border-b border-border bg-card shadow-sm">
        <div className="flex items-center gap-3">
          <button
            onClick={onClose}
            className="p-2 -ml-2 text-foreground/60 hover:text-foreground"
          >
            <X className="w-6 h-6" />
          </button>
          <h2 className="text-lg font-bold">Filters</h2>
        </div>
        <button
          onClick={() =>
            setSelectedFilters({
              "Vehicle Type": [],
              "Car Categories": [],
              "Price Range": [],
              Seating: [],
            })
          }
          className="text-sm font-semibold text-secondary hover:text-secondary/80"
        >
          Clear All
        </button>
      </div>

      {/* Body - Amazon Style Split */}
      <div className="flex flex-1 overflow-hidden bg-card">
        {/* Left Side - Tabs */}
        <div className="w-[35%] bg-accent/30 border-r border-border overflow-y-auto">
          {tabs.map((tab) => {
            const count = getSelectedCount(tab)
            const isActive = activeTab === tab
            return (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`w-full text-left px-4 py-4 border-l-4 transition-colors relative ${
                  isActive
                    ? "border-secondary bg-card font-bold text-primary"
                    : "border-transparent font-medium text-foreground/60 hover:bg-accent/50"
                }`}
              >
                <span className="text-sm">{tab}</span>
                {count > 0 && (
                  <span className="absolute top-1/2 -translate-y-1/2 right-2 w-5 h-5 rounded-full bg-secondary/10 text-secondary text-[10px] flex items-center justify-center font-bold">
                    {count}
                  </span>
                )}
              </button>
            )
          })}
        </div>

        {/* Right Side - Content */}
        <div className="w-[65%] overflow-y-auto bg-card">{renderContent()}</div>
      </div>

      {/* Footer */}
      <div className="p-4 border-t border-border bg-card shadow-[0_-4px_10px_rgba(0,0,0,0.03)] pb-safe">
        <button
          onClick={onClose}
          className="w-full bg-primary text-primary-foreground py-3.5 rounded-xl font-bold text-base hover:bg-primary/90 transition-colors shadow-sm flex items-center justify-center gap-2"
        >
          Show Results
          {totalSelections > 0 && (
            <span className="bg-white/20 px-2 py-0.5 rounded-full text-xs">
              {totalSelections}
            </span>
          )}
        </button>
      </div>
    </div>
  )
}
