import { useState } from 'react';
import { X, Search, Navigation, MapPin, Clock } from 'lucide-react';

interface LocationModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function LocationModal({ isOpen, onClose }: LocationModalProps) {
  const [searchQuery, setSearchQuery] = useState('');

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex flex-col bg-background animate-in slide-in-from-bottom-full duration-300">
      {/* Header */}
      <div className="flex items-center gap-3 px-4 py-4 border-b border-border bg-card shadow-sm">
        <button onClick={onClose} className="p-2 -ml-2 text-foreground/60 hover:text-foreground">
          <X className="w-6 h-6" />
        </button>
        <div className="flex-1">
          <h2 className="text-lg font-bold">Select Location</h2>
        </div>
      </div>

      <div className="p-4 bg-card">
        {/* Search */}
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-foreground/40" />
          <input 
            type="text" 
            placeholder="Search for area, street name..." 
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full bg-accent border border-border/50 rounded-xl py-3.5 pl-10 pr-4 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 placeholder:text-foreground/40 font-medium"
            autoFocus
          />
        </div>

        {/* Current Location Button */}
        <button className="flex items-center gap-3 mt-4 text-primary font-bold hover:opacity-80 transition-opacity w-full text-left">
          <div className="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center">
            <Navigation className="w-5 h-5" />
          </div>
          <div>
            <div className="text-sm">Use current location</div>
            <div className="text-xs text-foreground/50 font-medium mt-0.5">Using GPS</div>
          </div>
        </button>
      </div>

      <div className="h-2 bg-accent/50 w-full" />

      {/* Recent Locations */}
      <div className="flex-1 overflow-y-auto bg-card">
        <div className="p-4">
          <h3 className="text-xs font-bold text-foreground/50 uppercase tracking-wider mb-4">Saved & Recent Locations</h3>
          
          <div className="space-y-4">
            <button className="w-full flex items-start gap-3 text-left" onClick={onClose}>
              <div className="mt-0.5 text-foreground/40">
                <Clock className="w-5 h-5" />
              </div>
              <div className="flex-1 border-b border-border/50 pb-4">
                <div className="font-bold text-sm text-foreground">Madhapur</div>
                <div className="text-xs text-foreground/60 font-medium mt-1 truncate">Hitech City Road, Jubilee Hills, Hyderabad, Telangana 500081</div>
              </div>
            </button>
            
            <button className="w-full flex items-start gap-3 text-left" onClick={onClose}>
              <div className="mt-0.5 text-foreground/40">
                <Clock className="w-5 h-5" />
              </div>
              <div className="flex-1 border-b border-border/50 pb-4">
                <div className="font-bold text-sm text-foreground">Gachibowli</div>
                <div className="text-xs text-foreground/60 font-medium mt-1 truncate">Financial District, Nanakramguda, Hyderabad, Telangana 500032</div>
              </div>
            </button>
            
            <button className="w-full flex items-start gap-3 text-left" onClick={onClose}>
              <div className="mt-0.5 text-foreground/40">
                <MapPin className="w-5 h-5" />
              </div>
              <div className="flex-1 border-b border-border/50 pb-4">
                <div className="font-bold text-sm text-foreground">Rajiv Gandhi International Airport</div>
                <div className="text-xs text-foreground/60 font-medium mt-1 truncate">Shamshabad, Hyderabad, Telangana 500409</div>
              </div>
            </button>
          </div>
        </div>
      </div>
      
      {/* Visual map decoration at bottom */}
      <div className="h-48 relative border-t border-border bg-[#e5e7eb] overflow-hidden">
        <div className="absolute inset-0" style={{ backgroundImage: 'radial-gradient(#cbd5e1 2px, transparent 2px)', backgroundSize: '16px 16px' }} />
        <div className="absolute inset-0 bg-gradient-to-t from-background to-transparent" />
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-32 h-32 bg-primary/5 rounded-full animate-ping" />
        <MapPin className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-8 h-8 text-primary drop-shadow-md" />
      </div>
    </div>
  );
}
