import { useState } from "react"
import BottomNav from "./components/BottomNav"
import ExploreScreen from "./screens/ExploreScreen"
import SavedScreen from "./screens/SavedScreen"
import ProfileScreen from "./screens/ProfileScreen"
import LoginScreen from "./screens/LoginScreen"

export default function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false)
  const [activeTab, setActiveTab] = useState("explore")
  const [savedIds, setSavedIds] = useState<string[]>([])

  const toggleSave = (id: string) => {
    setSavedIds((prev) =>
      prev.includes(id) ? prev.filter((vid) => vid !== id) : [...prev, id],
    )
  }

  if (!isAuthenticated) {
    return (
      <div className="w-full max-w-md mx-auto bg-background min-h-screen relative shadow-2xl overflow-hidden sm:border-x sm:border-border">
        <LoginScreen onLogin={() => setIsAuthenticated(true)} />
      </div>
    )
  }

  return (
    <div className="w-full max-w-md mx-auto bg-background min-h-screen relative shadow-2xl overflow-hidden sm:border-x sm:border-border pb-28">
      {activeTab === "explore" && (
        <ExploreScreen savedIds={savedIds} onToggleSave={toggleSave} />
      )}

      {activeTab === "history" && (
        <div className="flex flex-col min-h-screen bg-background pb-24">
          <div className="bg-card px-4 pt-safe-top pb-4 border-b border-border sticky top-0 z-40">
            <h1 className="text-2xl font-bold mt-2">History</h1>
          </div>
          <div className="flex-1 flex items-center justify-center">
            <p className="text-foreground/50 font-medium">
              No past bookings found.
            </p>
          </div>
        </div>
      )}

      {activeTab === "saved" && (
        <SavedScreen savedIds={savedIds} onToggleSave={toggleSave} />
      )}

      {activeTab === "profile" && <ProfileScreen onLogout={() => setIsAuthenticated(false)} />}

      <BottomNav activeTab={activeTab} setActiveTab={setActiveTab} />
    </div>
  )
}
