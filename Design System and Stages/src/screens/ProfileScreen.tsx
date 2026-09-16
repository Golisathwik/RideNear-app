import {
  ChevronRight,
  CreditCard,
  Bell,
  HelpCircle,
  LogOut,
  FileText,
  Settings,
  ShieldCheck,
  UserCircle2,
} from "lucide-react"

interface ProfileScreenProps {
  onLogout: () => void;
}

export default function ProfileScreen({ onLogout }: ProfileScreenProps) {
  const profileOptions = [
    { icon: UserCircle2, label: "Edit Profile", border: true },
    { icon: CreditCard, label: "Payment Methods", border: true },
    { icon: FileText, label: "My Documents & KYC", border: true },
    { icon: Bell, label: "Notifications", border: true },
    { icon: ShieldCheck, label: "Privacy & Security", border: true },
    { icon: HelpCircle, label: "Help & Support", border: false },
  ]

  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header Profile Info */}
      <div className="bg-card px-4 pt-safe-top pb-6 border-b border-border shadow-sm">
        <h1 className="text-2xl font-bold mt-2 mb-6">Profile</h1>

        <div className="flex items-center gap-4">
          <div className="w-20 h-20 bg-accent rounded-full border-2 border-border overflow-hidden">
            <img
              src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80"
              alt="Profile"
              className="w-full h-full object-cover"
            />
          </div>
          <div>
            <h2 className="text-xl font-bold text-foreground">Alex John</h2>
            <p className="text-foreground/60 font-medium mt-1">
              +91 98765 43210
            </p>
            <div className="inline-block bg-secondary/10 text-secondary px-2 py-1 rounded mt-2 text-xs font-bold uppercase tracking-wider">
              KYC Verified
            </div>
          </div>
        </div>
      </div>

      <div className="mt-4">
        {/* Settings List */}
        <div className="bg-card border-y border-border">
          {profileOptions.map((option, index) => {
            const Icon = option.icon
            return (
              <button
                key={index}
                className="w-full flex items-center justify-between p-4 active:bg-accent transition-colors group"
              >
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-accent flex items-center justify-center group-active:bg-background transition-colors">
                    <Icon className="w-5 h-5 text-foreground/70" />
                  </div>
                  <span className="font-semibold">{option.label}</span>
                </div>
                <ChevronRight className="w-5 h-5 text-foreground/30" />
              </button>
            )
          })}
        </div>

        {/* Logout */}
        <div className="mt-6 px-4">
          <button 
            onClick={onLogout}
            className="w-full bg-accent text-foreground font-bold py-4 rounded-xl flex items-center justify-center gap-2 hover:bg-border transition-colors"
          >
            <LogOut className="w-5 h-5" /> Log Out
          </button>
        </div>
      </div>
    </div>
  )
}
