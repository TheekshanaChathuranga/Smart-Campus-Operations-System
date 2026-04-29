# Smart Campus Operations System

A comprehensive Flutter application for university campus operations management, featuring role-based authentication, timetable management, event registration with QR codes, campus mapping, real-time announcements, and push notifications.

## 🏗️ Architecture

This project follows **Clean Architecture** with three distinct layers per feature:

```
data/        → Models, Data Sources, Repository Implementations
domain/      → Entities, Abstract Repositories, Use Cases
presentation/ → Pages, Widgets, Riverpod Providers (StateNotifiers)
```

## 🚀 Features

| Feature | Description |
|---------|-------------|
| **Auth** | Login/Register with SHA-256 hashed passwords, role-based access (Student/Staff) |
| **Timetable** | Day-based class schedule with color-coded cards |
| **Events** | Browse events, register, get unique QR codes |
| **Announcements** | REST API-driven news feed with expandable cards |
| **Campus Map** | OpenStreetMap with campus landmarks and GPS location |
| **QR Scanner** | Scan QR codes with torch/camera controls |
| **Notifications** | Firebase Messaging integration (stubbed) |

## 📦 Tech Stack

- **State Management**: Riverpod (StateNotifier)
- **Routing**: go_router (ShellRoute + BottomNavigationBar)
- **Database**: SQLite via sqflite
- **HTTP Client**: Dio with interceptors
- **Maps**: flutter_map (OpenStreetMap)
- **QR**: qr_flutter (generation) + mobile_scanner (scanning)
- **Location**: geolocator
- **Theme**: Material 3 with Google Fonts (Inter)

## 🔐 Demo Credentials

| Role | Email | Password |
|------|-------|----------|
| Student | student@campus.edu | password |
| Staff | staff@campus.edu | password |

## 🛠️ Getting Started

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build APK
flutter build apk
```

## 📁 Project Structure

```
lib/
├── main.dart              # ProviderScope + bootstrap
├── app.dart               # MaterialApp.router
├── core/
│   ├── theme/             # Material 3 theming
│   ├── constants/         # API endpoints, UI strings
│   ├── error/             # Failures & Exceptions
│   ├── network/           # Dio client & interceptor
│   ├── database/          # SQLite helper & schema
│   ├── router/            # GoRouter & guards
│   └── di/                # Riverpod providers
├── features/
│   ├── auth/              # Authentication
│   ├── timetable/         # Class schedules
│   ├── events/            # Event registration
│   ├── announcements/     # News feed
│   ├── campus_map/        # Map & location
│   ├── qr_scanner/        # QR code scanning
│   └── notifications/     # Push notifications
└── shared/
    ├── widgets/           # Reusable UI components
    └── validators/        # Form validators
```

## 📋 SQLite Schema

```sql
users(id, name, email, password_hash, role, created_at)
events(id, title, description, date, location, capacity)
registrations(id, user_id FK→users, event_id FK→events, qr_code, registered_at)
timetable(id, subject, instructor, day, start_time, end_time, room, color)
```
