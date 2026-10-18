# 🛡️ KidShield — Cross-Platform Parental Control & Child Safety App

A complete, production-ready cross-platform Parental Control application built with **Flutter** (targeting Android, iOS, Web, and Windows) and **Firebase** backend.

---

## 🌟 Key Features

### 1. Unified Architecture & Operating Modes
- **Onboarding Mode Selector**: Allows configuring the device at first launch as either:
  - **Parent Dashboard (لوحة تحكم الأب)**: Manage protected children, view real-time location on maps, configure bedtime & screen time rules, and receive instant emergency sirens.
  - **Child Device (جهاز الطفل)**: Active protection shield with background GPS and battery telemetry, prominent SOS emergency button, and bedtime lock overlay.
- **Bilingual RTL / LTR Support**: Instant switching between **Arabic (العربية RTL)** and **English (LTR)** across all screens.

### 2. Device Pairing System
- **6-Digit PIN & QR Code**: The Parent generates a unique 6-digit numeric PIN with an interactive QR code.
- **Child Linker**: Child enters the PIN code or scans the QR code to instantly bind the device record in Firestore.

### 3. Real-Time Location & Telemetry
- **Continuous GPS Tracking**: Child device publishes live coordinates (`latitude`, `longitude`, `accuracy`) and battery percentage (`battery_plus`) to Firestore.
- **Parent Live Map**: Real-time map displaying the child's live location, distance accuracy, battery gauge, and safe geofence circle.

### 4. Emergency SOS Siren & Alert System
- **Prominent SOS Button**: Animated pulsing emergency button on the child dashboard.
- **High-Priority Broadcast**: Triggers an immediate audible siren on the parent dashboard and renders a persistent red alert banner with exact coordinates and a direct map link.

### 5. Screen Time & Bedtime Lock
- **Rules Controller**: Parent sets daily usage limits (in hours and minutes) and configures bedtime schedules (e.g., 21:00 to 07:00).
- **Instant Remote Lock**: Single-tap switch to instantly restrict the child's screen remotely.
- **Device Locked Overlay**: Calming night-themed overlay on the child's device restricting access during locked hours.

### 6. Native Platform Channels (Android & iOS)
- **MethodChannel (`com.parental.safety/app_manager`)**:
  - `checkUsageStatsPermission` & `requestUsageStatsPermission` (`android.permission.PACKAGE_USAGE_STATS`)
  - `checkAccessibilityPermission` & `requestAccessibilityPermission` (`ChildAccessibilityService.kt`)
  - `startLocationForegroundService` (`LocationForegroundService.kt`)
  - `getDailyAppUsage` (`UsageStatsManager`)
  - `requestFamilyControls` (iOS 16+ FamilyControls API stub)

---

## 🚀 How to Run & Test

### Run on Chrome/Web (Immediate UI Simulation)
```bash
flutter run -d chrome
```
*Note: The app includes a built-in reactive Mock Store fallback that runs immediately even before configuring your own Firebase credentials.*

### Run on Android
```bash
flutter run -d android
```

### Run on iOS
```bash
flutter run -d ios
```

### Run on Windows
```bash
flutter run -d windows
```

---

## 📁 Clean Architecture Directory Overview

```text
lib/
├── core/
│   ├── constants/           # AppColors, AppConstants, FirestoreCollections
│   ├── l10n/                # AppLocalizations (Arabic RTL & English)
│   ├── services/            # LocationService, BatteryService, AudioAlertService, PlatformChannelService
│   └── theme/               # AppTheme (Material 3)
├── data/
│   ├── models/              # ChildDeviceModel, PairingCodeModel, RulesModel, SosAlertModel
│   └── repositories/        # AuthRepository, ParentRepository, ChildRepository, PairingRepository, MockDataStore
├── providers/               # AppModeProvider, AuthProvider, ParentDashboardProvider, ChildTelemetryProvider, RulesProvider, SosAlertProvider
├── presentation/
│   ├── onboarding/          # RoleSelectionScreen (Parent vs Child mode & Language toggle)
│   ├── features/parent/     # ParentAuth, ParentDashboard, LiveMap, DevicePairing, RulesController
│   └── features/child/      # ChildPairing, ChildDashboard, SosButtonWidget, DeviceLockedScreen
└── main.dart                # MultiProvider & MaterialApp setup
```
