# Smart Campus Operations System - Project Report

## 1. Introduction
The **Smart Campus Operations System** is a comprehensive Flutter-based mobile application designed to streamline university campus management. It caters to both students and staff, offering role-based access to features like timetable management, event registrations with QR code scanning, real-time announcements, and campus navigation.

## 2. Objectives
- Provide a centralized platform for students to access their class schedules, register for campus events, and receive critical university announcements.
- Empower university staff with administrative tools to manage timetables, create new events, and broadcast announcements.
- Enhance event management through automated QR code-based check-ins, eliminating manual attendance tracking.
- Improve campus navigation with an integrated, interactive campus map.

## 3. Technology Stack
- **Frontend/Framework:** Flutter (>=3.10.7)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Routing:** GoRouter (`go_router`)
- **Local Database:** SQLite (`sqflite`)
- **Networking:** Dio (`dio`)
- **QR Code Handling:** `qr_flutter` (generation), `mobile_scanner` (scanning)
- **Mapping & Location:** `flutter_map`, `geolocator`
- **Notifications:** Firebase Cloud Messaging (`firebase_messaging`), Local Notifications (`flutter_local_notifications`)

## 4. Software Architecture
The application strictly follows **Clean Architecture** principles, ensuring separation of concerns, scalability, and testability. The architecture is divided into three primary layers for each feature:

1. **Presentation Layer:** Contains UI components (Pages, Widgets) and State Management (Riverpod Notifiers).
2. **Domain Layer:** Contains core business logic, Entities, and abstract Repositories (Interfaces).
3. **Data Layer:** Contains Models (data structures), Data Sources (Local SQLite, Remote API via Dio), and concrete Repository Implementations.

## 5. Key Modules
### 5.1. Authentication & Authorization
Role-based authentication system supporting "Student" and "Staff" roles. Access to certain pages and administrative functions is strictly controlled based on the authenticated user's role.

### 5.2. Timetable Management
Allows students to view their weekly class schedules. Staff members can create, update, and delete timetable entries, including details like subject, instructor, time, room, and color coding.

### 5.3. Event Management & QR Check-ins
Staff can organize events specifying capacity and location. Students can register for these events, receiving a unique QR code upon successful registration. Staff use the built-in QR scanner to quickly verify and check-in attendees at the venue.

### 5.4. Real-time Announcements
A broadcast system for university-wide or category-specific announcements. Staff can publish notices, and students receive real-time updates via push notifications.

### 5.5. Campus Map
An interactive map module utilizing OpenStreetMap (via `flutter_map`) to help users navigate the university campus, locate specific buildings, and find event venues.

## 6. Database Design
The application utilizes a local SQLite database for persistent offline storage. The core tables include:
- `users`: Stores user credentials and roles.
- `events`: Stores event details (time, location, capacity).
- `registrations`: Tracks student registrations for events, storing the unique QR code and check-in status.
- `announcements`: Stores university notices.
- `timetable`: Stores the weekly class schedule.

## 7. Conclusion
The Smart Campus Operations System successfully modernizes university administration by consolidating essential services into a single, intuitive mobile application. Its modular architecture ensures it can easily be expanded with new features in the future, providing a scalable foundation for a truly "smart" campus ecosystem.

> **Note on PDF format:** You can easily convert this Markdown document into a PDF using popular text editors like VS Code (via extensions like "Markdown PDF") or online Markdown to PDF converters.
