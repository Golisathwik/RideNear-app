import { Compass, Clock, Heart, User } from "lucide-react"

interface BottomNavProps {
  activeTab: string
  setActiveTab: (tab: string) => void
}

export default function BottomNav({ activeTab, setActiveTab }: BottomNavProps) {
  const tabs = [
    { id: "explore", label: "Explore", icon: Compass },
    { id: "history", label: "History", icon: Clock },
    { id: "saved", label: "Saved", icon: Heart },
    { id: "profile", label: "Profile", icon: User },
  ]

  return (
    <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-md bg-card rounded-t-[32px] border-t border-x border-border/50 shadow-[0_-10px_40px_rgba(0,0,0,0.08)] px-8 py-4 pb-safe flex justify-between items-center z-50">
      {tabs.map((tab) => {
        const Icon = tab.icon
        const isActive = activeTab === tab.id
        return (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`flex flex-col items-center gap-1 transition-all ${
              isActive
                ? "text-primary scale-105"
                : "text-foreground/40 hover:text-foreground/80"
            }`}
          >
            <Icon
              className="w-[26px] h-[26px]"
              strokeWidth={isActive ? 2.5 : 2}
              fill={isActive && tab.id !== "history" ? "currentColor" : "none"}
            />
            <span
              className={`text-[10px] ${
                isActive ? "font-bold" : "font-medium"
              }`}
            >
              {tab.label}
            </span>
          </button>
        )
      })}
    </div>
  )
}
