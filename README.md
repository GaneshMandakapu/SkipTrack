# SkipTrack - Professional Jump Rope Fitness App

A comprehensive iOS fitness app for jump rope tracking with iPhone motion detection and AirPods audio integration.

## ✨ Features

### 🏃‍♂️ **Workout Tracking**
- Real-time jump counting using iPhone motion sensors
- Professional workout plans (Beginner/Intermediate/Advanced)
- Apple Fitness-style activity rings
- Comprehensive workout history and statistics
- Trophy system and achievements

### 🎧 **AirPods Integration**
- High-quality audio feedback through AirPods
- Connection status monitoring
- Audio cues for workouts and achievements
- **Note**: Uses iPhone motion detection + AirPods audio (iOS limitation)

### 🎯 **Professional Features**
- Siri Shortcuts integration ("Start Skipping")
- Custom app icons and professional design
- Manual jump counting backup system
- Workout plans with progressive difficulty
- Activity tracking with visual progress indicators

### 📱 **Technical Implementation**
- SwiftUI-based modern interface
- CoreMotion for accurate jump detection
- AVFoundation for AirPods integration
- HealthKit integration ready
- Professional code architecture

## 🛠 **Technology Stack**

- **Framework**: SwiftUI (iOS 15+)
- **Motion Detection**: CoreMotion
- **Audio**: AVFoundation + AudioToolbox
- **Bluetooth**: CoreBluetooth
- **Architecture**: MVVM with Combine
- **Build System**: Xcode 15+

## 📱 **System Requirements**

- iOS 15.0 or later
- iPhone with motion sensors
- AirPods (recommended for best experience)
- 50MB storage space

## 🚀 **Getting Started**

### **Installation**
1. Download from TestFlight or App Store
2. Connect your AirPods
3. Launch SkipTrack
4. Complete the welcome tutorial
5. Start jumping!

### **Best Usage**
- **Phone placement**: Pocket, table, or hold steady
- **AirPods**: Connected for audio feedback
- **Environment**: Open space for jumping
- **Backup**: Use manual counting for accuracy

## 🎯 **Workout Plans**

### **Beginner (4 weeks)**
- Week 1-2: Basic rhythm building
- Week 3-4: Endurance foundation
- Focus: Form and consistency

### **Intermediate (6 weeks)**
- Week 1-3: Speed development
- Week 4-6: Complex combinations
- Focus: Technique and variety

### **Advanced (8 weeks)**
- Week 1-4: High-intensity intervals
- Week 5-8: Competition preparation
- Focus: Performance and endurance

## 📊 **Features Overview**

| Feature | Description | Status |
|---------|-------------|--------|
| Jump Detection | iPhone motion sensors | ✅ Active |
| AirPods Audio | Sound feedback | ✅ Active |
| Workout Plans | 3 difficulty levels | ✅ Active |
| History Tracking | Complete statistics | ✅ Active |
| Siri Integration | Voice commands | ✅ Active |
| Manual Counting | Backup system | ✅ Active |
| Apple Watch | Motion detection | 🔄 Future |
| HealthKit | Data export | 🔄 Future |

## 🔧 **Technical Honesty**

### **Motion Detection Reality**
- **iPhone sensors**: Primary detection method
- **AirPods limitation**: iOS doesn't expose AirPods motion data to third-party apps
- **Industry standard**: All fitness apps use phone/watch motion detection
- **Our approach**: Transparent about technical capabilities

### **What Makes SkipTrack Different**
- ✅ **Honest implementation** - clear about technical limitations
- ✅ **Professional quality** - Apple Fitness-style interface
- ✅ **Comprehensive features** - complete fitness ecosystem
- ✅ **User-focused** - manual backup for accuracy
- ✅ **Regular updates** - continuous improvement

## 📁 **Project Structure**

```
SkipTrack/
├── SkipTrack/
│   ├── Managers/
│   │   ├── BluetoothManager.swift     # AirPods integration
│   │   ├── SiriShortcutManager.swift  # Voice commands
│   │   └── WorkoutManager.swift       # Fitness logic
│   ├── ViewModels/
│   │   └── WorkoutViewModel.swift     # MVVM architecture
│   ├── Views/
│   │   ├── MainView.swift            # Primary interface
│   │   ├── WorkoutDetailView.swift   # Workout plans
│   │   ├── HistoryView.swift         # Statistics
│   │   └── TrophyView.swift          # Achievements
│   ├── Models/
│   │   └── Workout.swift             # Data structures
│   └── Extensions/
│       └── TimeInterval+Format.swift # Utilities
├── Assets.xcassets/                   # Icons and images
├── Documentation/                     # Guides and specs
└── Distribution/                      # Build artifacts
```

## 🚀 **Development**

### **Building the App**
```bash
# Open in Xcode
open SkipTrack.xcodeproj

# Build for device
xcodebuild -project SkipTrack.xcodeproj \
           -scheme SkipTrack \
           -configuration Release \
           -destination generic/platform=iOS \
           archive
```

### **Key Development Notes**
- Minimum deployment target: iOS 15.0
- Code signing: Apple Developer Account required
- Testing: Requires physical device for motion sensors
- AirPods: Test with actual AirPods for audio integration

## 📱 **Distribution**

The app is ready for distribution via:
- **TestFlight** (recommended for friends/testing)
- **App Store** (public release)
- **Ad Hoc** (limited device distribution)

See `DISTRIBUTION_GUIDE.md` for detailed instructions.

## 🤝 **Contributing**

### **Areas for Improvement**
- Apple Watch integration for better motion detection
- HealthKit data export
- Social features and challenges
- Additional workout types
- Customizable audio feedback

### **Technical Debt**
- Unit test coverage
- UI test automation
- Performance optimization
- Accessibility improvements

## 📄 **License**

Private project - All rights reserved.

## 👨‍💻 **Author**

Created with attention to technical accuracy and user experience.

---

**SkipTrack** - Honest fitness tracking with professional quality. 🏃‍♂️
