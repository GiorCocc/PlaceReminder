# 📍 PlaceReminder

[![iOS](https://img.shields.io/badge/iOS-16.4%2B-blue.svg)](https://developer.apple.com/ios/)
[![Xcode](https://img.shields.io/badge/Xcode-14%2B-blue.svg)](https://developer.apple.com/xcode/)
[![Objective-C](https://img.shields.io/badge/Language-Objective--C-orange.svg)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#license)

**PlaceReminder** is an intuitive iOS application written in Objective-C that empowers users to save their favorite places and receive intelligent location-based notifications when they're nearby. Never forget an important location again!

> 🎓 This application was developed as a comprehensive project for the Mobile Development course at the University of Parma, showcasing modern iOS development practices and location-based services.

## 📋 Table of Contents

- [📍 PlaceReminder](#-placereminder)
  - [📋 Table of Contents](#-table-of-contents)
  - [✨ Features](#-features)
  - [🚀 Future Enhancements](#-future-enhancements)
  - [📱 Requirements](#-requirements)
  - [⚙️ Installation & Setup](#️-installation--setup)
  - [📖 User Guide](#-user-guide)
    - [🏠 Home Screen](#-home-screen)
    - [➕ Adding Places](#-adding-places)
    - [📋 Place Details](#-place-details)
    - [🗺️ Map View](#️-map-view)
    - [🔒 Permissions](#-permissions)
  - [🏗️ Technical Architecture](#️-technical-architecture)
    - [📊 Database Design](#-database-design)
    - [🗺️ MapKit Integration](#️-mapkit-integration)
    - [📍 Geofencing System](#-geofencing-system)
  - [🤝 Contributing](#-contributing)
  - [📄 License](#-license)
  - [👤 Contact](#-contact)

## ✨ Features

PlaceReminder offers a comprehensive suite of location-based features designed to help you remember and manage your important places:

### 🎯 Core Functionality
- **📍 Place Management**: Save unlimited places with detailed information including:
  - 🌍 Geographic coordinates and full address
  - 📝 Custom name and optional description
  - 📅 Automatic timestamp recording
  - 🔔 Optional location-based reminders

### 🗺️ Intelligent Mapping
- **📊 Multiple Views**: Switch between list and map views for optimal place browsing
- **📌 Interactive Markers**: Tap map markers to view place details and distance information
- **🧭 Location Services**: Real-time user location tracking and display
- **🍎 Apple Maps Integration**: Seamlessly view places in the native Maps app

### 🔔 Smart Notifications
- **⚡ Geofencing Technology**: Automatic notifications when entering saved place regions
- **🎯 Proximity Alerts**: Customizable 500-meter radius notifications
- **🔕 Background Processing**: Receive notifications even when the app is closed

### ✏️ Place Management
- **✏️ Full Editing**: Modify any saved place information
- **🗑️ Easy Deletion**: Remove places with simple gestures
- **🔍 Smart Address Completion**: Partial address input with automatic geocoding

## 🚀 Future Enhancements

The following features are planned for future releases:

### ✅ Completed
- [x] **Smart Address Input**: Partial address completion with geocoding
- [x] **Current Location**: Auto-fill address with current GPS location

### 🚧 In Development
- [ ] **📂 Place Categories**: Organize places (work, home, entertainment, etc.)
- [ ] **📸 Photo Attachments**: Add visual memories to your places
- [ ] **🎤 Voice Notes**: Record audio reminders for each location
- [ ] **📏 Custom Radius**: Adjustable geofence radius per place
- [ ] **📊 Visit Statistics**: Track frequency and duration of visits
- [ ] **🌙 Dark Mode**: Full dark theme support

## 📱 Requirements

### System Requirements
- **📱 iOS**: 16.4 or later
- **💾 Storage**: 50 MB available space
- **🌐 Network**: Internet connection for geocoding services
- **📍 GPS**: Location services capability

### Development Requirements
- **🛠️ Xcode**: 14.0 or later
- **💻 macOS**: Monterey 12.0 or later
- **📱 iOS SDK**: 16.4 or later
- **🎯 Target**: iOS 16.4+
- **🔧 Language**: Objective-C

### Device Compatibility
- **📱 iPhone**: iPhone 8 and later
- **📟 iPad**: iPad (6th generation) and later
- **📱 iPod touch**: 7th generation

## ⚙️ Installation & Setup

### 📥 For End Users

#### Option 1: App Store (Recommended)
> 🚧 *Coming Soon* - The app will be available on the App Store

#### Option 2: TestFlight Beta
> 🚧 *Coming Soon* - Beta testing via TestFlight

#### Option 3: Developer Installation
If you have access to the source code and a developer account:

1. **Prerequisites**: Ensure you have Xcode 14+ installed
2. **Clone Repository**: Download or clone the project
3. **Open Project**: Launch `PlaceReminder.xcodeproj` in Xcode
4. **Set Team**: Configure your Apple Developer Team in project settings
5. **Build & Run**: Connect your device and install via Xcode

### 🛠️ For Developers

#### Setting up the Development Environment

1. **Clone the Repository**
   ```bash
   git clone https://github.com/GiorCocc/PlaceReminder.git
   cd PlaceReminder
   ```

2. **Open in Xcode**
   ```bash
   open PlaceReminder.xcodeproj
   ```

3. **Configure Code Signing**
   - Select the `PlaceReminder` target
   - Navigate to "Signing & Capabilities"
   - Set your Team and Bundle Identifier

4. **Build the Project**
   - Use `⌘+B` to build
   - Use `⌘+R` to run on simulator or device

#### Project Dependencies
This project uses the following iOS frameworks:
- **🗺️ MapKit**: For map display and location services
- **💾 CoreData**: For local data persistence
- **📍 CoreLocation**: For location tracking and geofencing
- **🔔 UserNotifications**: For location-based alerts
- **🎨 UIKit**: For user interface components

> 📝 **Note**: No external dependencies or CocoaPods required - all frameworks are part of iOS SDK

## 📖 User Guide

PlaceReminder features an intuitive interface designed for effortless place management. Below is a comprehensive guide to each screen and feature.

### 🏠 Home Screen

The home screen is your central hub for accessing all saved places and primary app functions.

<img src="./img/home.png" alt="Home Screen" width="200"/>

**Key Features:**
- **🗺️ Interactive Map**: Displays your current location and all saved places as markers
- **📋 Place List**: Scrollable table showing places sorted by date added (most recent first)
- **➕ Add Place Button**: Quick access to save new locations (top navigation bar)
- **🔍 Map Toggle**: Switch to full-screen map view for better exploration

**Navigation:**
- **Tap any place** in the list to view detailed information
- **Tap map markers** to see place name and distance from your location
- **Pull to refresh** the list to update locations and distances

### ➕ Adding Places

The add place screen provides a comprehensive interface for saving new locations with detailed information.

<img src="./img/add.png" alt="Add New Place" width="200"/>

**Required Information:**
- **📝 Place Name**: Custom identifier for your location
- **📍 Address**: Full or partial address (auto-completed via Apple Maps)

**Optional Features:**
- **🔔 Reminder Toggle**: Enable location-based notifications
- **📝 Notes**: Personal notes about why this place is important
- **📍 Current Location**: Auto-fill with your current GPS coordinates

**Smart Address Input:**
- Enter partial addresses (e.g., "Central Park, NY")
- System automatically completes missing information
- Real-time address validation through Apple's geocoding services
- Preview location on integrated map before saving

**Validation:**
- Name and address fields are **required**
- Address must be geocodable (valid location)
- Duplicate places are allowed (useful for different purposes)

### 📋 Place Details

The place details screen provides comprehensive information about saved locations and management options.

<img src="./img/details.png" alt="Place Details" width="200"/>

**Information Displayed:**
- **📍 Location**: Full address and coordinates
- **📝 Details**: Name, description, and personal notes  
- **📅 Metadata**: Date and time when place was added
- **🔔 Reminder Status**: Whether notifications are enabled
- **🗺️ Mini Map**: Visual location preview with your position (if nearby)

**Available Actions:**
- **✏️ Edit**: Modify any place information
- **🍎 Open in Maps**: View location in Apple Maps app
- **🗑️ Delete**: Remove place from your saved list
- **📤 Share**: Share place information with others

**Distance Information:**
- Real-time distance calculation from your current location
- Updates automatically as you move
- Displayed in both metric and imperial units based on device settings

### 🗺️ Map View

The full-screen map provides an immersive way to explore your saved places and surroundings.

<img src="./img/map.png" alt="Full Map View" width="200"/>

**Map Features:**
- **📍 Your Location**: Blue dot showing current GPS position
- **📌 Place Markers**: Red pins for all saved locations
- **🎯 Interactive Callouts**: Tap markers to see place information
- **🔍 Zoom Controls**: Pinch to zoom in/out for different perspectives
- **🧭 Location Tracking**: Map follows your movement in real-time

**Marker Interactions:**
- **Single Tap**: Show place name and distance
- **Callout Tap**: Navigate to detailed place information
- **Long Press**: Quick preview of place details

### 🔒 Permissions

PlaceReminder requires specific permissions to provide its full functionality:

#### 📍 Location Services
**Required for:**
- Displaying your position on maps
- Calculating distances to saved places
- Triggering location-based notifications
- Auto-filling current location when adding places

**Permission Levels:**
- **"When Using App"**: Basic functionality with manual refresh
- **"Always"** (Recommended): Background location monitoring for notifications

#### 🔔 Notifications  
**Required for:**
- Proximity alerts when approaching saved places
- Background reminders even when app is closed
- Custom notification sounds and badges

**Setup Process:**
1. **First Launch**: App automatically requests permissions
2. **Location Prompt**: Choose "Allow While Using App" or "Allow Always"
3. **Notification Prompt**: Tap "Allow" for full notification support
4. **Settings**: Modify permissions anytime in iOS Settings > PlaceReminder

> ⚠️ **Privacy Note**: All location data is stored locally on your device. No information is shared with third parties except Apple Maps for geocoding services.

## 🏗️ Technical Architecture

PlaceReminder is built using modern iOS development practices and follows the **Model-View-Controller (MVC)** architectural pattern for clean code organization and maintainability.

### 🏛️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     View        │    │   Controller    │    │     Model       │
│                 │    │                 │    │                 │
│ • Storyboard    │◄──►│ • ViewControllers│◄──►│ • CoreData      │
│ • XIB Files     │    │ • Delegates     │    │ • PlaceMO       │
│ • UITableView   │    │ • DataSources   │    │ • CoreDataMgr   │
│ • MKMapView     │    │ • IBActions     │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │   Frameworks    │
                    │                 │
                    │ • MapKit        │
                    │ • CoreLocation  │
                    │ • UserNotifications │
                    │ • CoreData      │
                    └─────────────────┘
```

### 📁 Project Structure

The project is organized into logical groups for optimal code maintenance:

```
PlaceReminder/
├── 📱 App Lifecycle
│   ├── AppDelegate.h/m          # App lifecycle and notifications
│   ├── SceneDelegate.h/m        # Scene management (iOS 13+)
│   └── main.m                   # App entry point
│
├── 🎮 Controllers/
│   ├── HomePageViewController   # Main screen with map and list
│   ├── AddNewPlaceTableViewController # Add/edit place form
│   ├── PlaceDetailsViewController # Place information display
│   ├── MapViewController        # Full-screen map view
│   └── ViewController           # Base view controller
│
├── 🏗️ Models/
│   ├── PlaceMO+CoreDataClass    # Core Data managed object
│   ├── PlaceMO+CoreDataProperties # Auto-generated properties
│   └── MapAnnotation            # Custom map pin annotations
│
├── 💾 DataModel/
│   ├── CoreDataManager          # Core Data stack management
│   └── PlaceCoreDataModel.xcdatamodeld # Data model definition
│
├── 🎨 Views/
│   ├── Main.storyboard          # Primary UI layouts
│   ├── LaunchScreen.storyboard  # App launch screen
│   └── TextFieldTableViewCell  # Custom table cell components
│
└── 📦 Resources/
    ├── Assets.xcassets          # App icons and images
    ├── Info.plist              # App configuration
    └── en.lproj/               # Localization resources
```

### 🎮 View Controller Architecture

#### **HomePageViewController**
- **Purpose**: Main application hub combining map and list views
- **Components**: 
  - `MKMapView` for interactive location display
  - `UITableView` for place list management
  - Navigation controls for app-wide actions
- **Responsibilities**:
  - Real-time location tracking and display
  - Place list management and sorting
  - Map annotation handling and user interactions

#### **AddNewPlaceTableViewController**
- **Purpose**: Form interface for creating and editing places
- **Components**: Static `UITableView` with specialized cells
- **Features**:
  - Smart address completion with geocoding
  - Current location auto-fill capability
  - Input validation and error handling
  - Dual-purpose design (add new/edit existing)

#### **PlaceDetailsViewController**
- **Purpose**: Comprehensive place information display
- **Components**: Static table layout with action buttons
- **Features**:
  - Complete place information presentation
  - Edit/delete action management
  - Apple Maps integration
  - Distance calculation and display

#### **MapViewController**
- **Purpose**: Full-screen immersive map experience
- **Components**: Single `MKMapView` with enhanced interactions
- **Features**:
  - Full-screen place exploration
  - Enhanced marker interactions
  - Seamless navigation to place details

### 📊 Database Design

PlaceReminder uses **Core Data** for robust local data persistence with optimal performance and data integrity.

#### **PlaceMO Entity Structure**

```objc
// PlaceMO+CoreDataProperties.h

@interface PlaceMO : NSManagedObject

@property (nonatomic, retain) NSString *address;      // Human-readable address ⚠️ REQUIRED
@property (nonatomic, retain) NSString *name;         // User-defined place name ⚠️ REQUIRED  
@property (nonatomic, retain) NSString *notes;        // Optional user notes
@property (nonatomic) BOOL remember;                  // Geofencing enabled flag
@property (nonatomic, retain) NSDate *insert_time;    // Auto-generated timestamp
@property (nonatomic) double latitude;                // Auto-geocoded coordinate
@property (nonatomic) double longitude;               // Auto-geocoded coordinate

@end
```

#### **Data Flow Process**

1. **User Input**: Name and address (required fields)
2. **Geocoding**: Apple Maps converts address to coordinates
3. **Validation**: Ensures geocoding success before save
4. **Persistence**: Core Data saves to local SQLite database
5. **Retrieval**: Fetch with automatic sorting by insertion date

#### **Core Data Stack**

```objc
// CoreDataManager.h - Singleton pattern for data management

@interface CoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedManager;
- (void)saveContext;

@end
```

### 🗺️ MapKit Integration

PlaceReminder leverages **MapKit** framework for sophisticated location services and map visualization.

#### **Location Services Setup**

```objc
// HomePageViewController.m - Location manager configuration

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure map view
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    // Initialize location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Request permissions
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}
```

#### **Custom Annotations**

```objc
// MapAnnotation.h - Custom pin annotations for saved places

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) PlaceMO *place;

@end
```

#### **Address Geocoding Process**

1. **User Input**: Partial or complete address
2. **CLGeocoder**: Apple's service converts text to coordinates
3. **Validation**: Ensures valid location results
4. **Reverse Geocoding**: Fills missing address components
5. **Coordinate Storage**: Saves lat/lng for map display

### 📍 Geofencing System

Advanced proximity monitoring using **Core Location** for intelligent location-based notifications.

#### **Geofence Region Creation**

```objc
// AppDelegate.m - Setting up geofencing for saved places

- (void)setupGeofencingForPlaces:(NSArray<PlaceMO *> *)places {
    for (PlaceMO *place in places) {
        if (place.remember) {
            // Create circular region (500m radius)
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(place.latitude, place.longitude);
            CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center 
                                                                          radius:500.0 
                                                                      identifier:place.name];
            
            // Configure for entry notifications
            region.notifyOnEntry = YES;
            region.notifyOnExit = NO;
            
            // Start monitoring
            [self.locationManager startMonitoringForRegion:region];
        }
    }
}
```

#### **Notification Handling**

```objc
// AppDelegate.m - Processing geofence entry events

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSString *placeName = region.identifier;
    NSString *title = [NSString stringWithFormat:@"📍 Near %@", placeName];
    NSString *body = [NSString stringWithFormat:@"%@ is one of your important places!", placeName];
    
    [self scheduleNotificationWithTitle:title body:body];
}

- (void)scheduleNotificationWithTitle:(NSString *)title body:(NSString *)body {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body = body;
    content.sound = UNNotificationSound.defaultSound;
    content.badge = @1;
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger 
                                                   triggerWithTimeInterval:1 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest 
                                      requestWithIdentifier:[[NSUUID UUID] UUIDString]
                                      content:content 
                                      trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] 
     addNotificationRequest:request withCompletionHandler:nil];
}
```

#### **Privacy & Performance**

- **Local Processing**: All location data remains on device
- **Battery Optimization**: Efficient geofencing with 500m radius
- **Permission Handling**: Graceful degradation without location access
- **Background Capability**: Notifications work when app is closed

## 🤝 Contributing

We welcome contributions from the community! PlaceReminder is an open-source educational project, and we appreciate any help in making it better.

### 🚀 Ways to Contribute

- **🐛 Bug Reports**: Found an issue? [Open an issue](https://github.com/GiorCocc/PlaceReminder/issues)
- **✨ Feature Requests**: Have an idea? [Suggest a feature](https://github.com/GiorCocc/PlaceReminder/issues)
- **💻 Code Contributions**: Submit pull requests for improvements
- **📚 Documentation**: Help improve this README or add code comments
- **🌍 Localization**: Translate the app to new languages
- **🧪 Testing**: Help test the app on different devices and iOS versions

### 📋 Development Guidelines

#### Before Contributing
1. **📖 Read** this README thoroughly
2. **🔍 Search** existing issues to avoid duplicates
3. **💬 Discuss** major changes by opening an issue first

#### Code Standards
- **📝 Language**: Objective-C following Apple's conventions
- **🏗️ Architecture**: Maintain MVC pattern
- **📱 Compatibility**: Support iOS 16.4+
- **🧹 Code Style**: Follow existing formatting and naming conventions
- **📄 Documentation**: Comment complex logic and public interfaces

#### Pull Request Process
1. **🔀 Fork** the repository
2. **🌿 Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **✅ Test** your changes thoroughly
4. **💾 Commit** with clear, descriptive messages
5. **📤 Push** to your fork (`git push origin feature/amazing-feature`)
6. **🔃 Submit** a pull request with detailed description

#### Commit Message Format
```
📝 type(scope): brief description

🔹 Longer description explaining what and why
🔹 Reference any related issues (#123)

Examples:
✨ feat(geofencing): add custom radius support
🐛 fix(maps): resolve annotation clustering issue
📚 docs(readme): update installation instructions
```

### 🧪 Testing Guidelines

- **📱 Device Testing**: Test on multiple iOS devices and versions
- **🌍 Location Testing**: Verify geofencing in different locations
- **🔋 Battery Impact**: Ensure location services don't drain battery
- **🔒 Privacy**: Verify no data leaks or unauthorized access
- **♿ Accessibility**: Check VoiceOver and accessibility features

### 📞 Getting Help

- **❓ Questions**: Use [GitHub Discussions](https://github.com/GiorCocc/PlaceReminder/discussions)
- **🐛 Bug Reports**: [Open an Issue](https://github.com/GiorCocc/PlaceReminder/issues)
- **💬 Real-time Chat**: Contact maintainers directly (see contact section)

## 📄 License

This project is licensed under the **MIT License** - see the details below.

### MIT License

```
MIT License

Copyright (c) 2023 Giorgio Coccapani

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### 🔓 What This Means

✅ **You CAN:**
- Use this software for personal and commercial projects
- Modify and distribute the code
- Include it in proprietary software
- Sell applications based on this code

❌ **You CANNOT:**
- Hold the authors liable for any damages
- Use the authors' names for endorsement without permission

⚠️ **You MUST:**
- Include the original copyright notice
- Include the license text in any distribution

### 🙏 Third-Party Acknowledgments

This project uses the following Apple frameworks and services:

- **🗺️ MapKit Framework** - © Apple Inc. (Map display and location services)
- **📍 Core Location Framework** - © Apple Inc. (GPS and geofencing)
- **💾 Core Data Framework** - © Apple Inc. (Local data persistence)
- **🔔 User Notifications Framework** - © Apple Inc. (Push notifications)
- **🍎 Apple Maps Geocoding Services** - © Apple Inc. (Address resolution)

## 👤 Contact

### 👨‍💻 Project Maintainer

**Giorgio Coccapani**
- **🐙 GitHub**: [@GiorCocc](https://github.com/GiorCocc)
- **🎓 University**: University of Parma - Mobile Development Course
- **📍 Location**: Parma, Italy

### 🏫 Academic Context

This project was developed as part of the **Mobile Development** course at the **University of Parma**, demonstrating practical application of:

- iOS app development with Objective-C
- Location-based services and geofencing
- Core Data persistence and management
- MapKit integration and custom annotations
- User notification systems
- MVC architectural patterns

### 🔗 Project Links

- **📂 Repository**: [https://github.com/GiorCocc/PlaceReminder](https://github.com/GiorCocc/PlaceReminder)
- **🐛 Issues**: [Report bugs or request features](https://github.com/GiorCocc/PlaceReminder/issues)
- **💬 Discussions**: [Community discussions](https://github.com/GiorCocc/PlaceReminder/discussions)
- **📚 Documentation**: [Wiki pages](https://github.com/GiorCocc/PlaceReminder/wiki) (Coming Soon)

### 💝 Acknowledgments

Special thanks to:

- **🏫 University of Parma** - For providing excellent mobile development education
- **👩‍🏫 Course Instructors [Simone Cirani](https://github.com/simonecirani)** - For guidance and project requirements
- **🍎 Apple Developer Documentation** - For comprehensive iOS development resources
- **🌟 Open Source Community** - For inspiration and best practices

---

<div align="center">

**⭐ If you found this project helpful, please give it a star!**

Made with ❤️ in Italy 🇮🇹

</div>
