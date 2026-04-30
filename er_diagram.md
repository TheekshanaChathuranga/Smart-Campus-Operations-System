# Database Entity-Relationship (ER) Diagram

The following is the Entity-Relationship Diagram for the Smart Campus Operations System SQLite database.

```mermaid
erDiagram
    users {
        INTEGER id PK
        TEXT name
        TEXT email "UNIQUE"
        TEXT password_hash
        TEXT role "DEFAULT 'student'"
        TEXT created_at
    }

    events {
        INTEGER id PK
        TEXT title
        TEXT description
        TEXT date
        TEXT location
        INTEGER capacity "DEFAULT 0"
    }

    registrations {
        INTEGER id PK
        INTEGER user_id FK
        INTEGER event_id FK
        TEXT qr_code "UNIQUE"
        TEXT status "DEFAULT 'registered'"
        TEXT registered_at
    }

    announcements {
        INTEGER id PK
        TEXT title
        TEXT body
        TEXT category "DEFAULT 'General'"
        INTEGER author_id FK
        TEXT published_at
    }

    timetable {
        INTEGER id PK
        TEXT subject
        TEXT instructor
        TEXT day
        TEXT start_time
        TEXT end_time
        TEXT room
        INTEGER color "DEFAULT 0xFF6C63FF"
    }

    users ||--o{ registrations : "registers for"
    events ||--o{ registrations : "has"
    users ||--o{ announcements : "authors (staff)"
```

### Table Descriptions:
- **`users`**: Stores authentication credentials, basic info, and the user's role (`student` or `staff`).
- **`events`**: Defines events created by staff, including their capacity and location.
- **`registrations`**: Acts as a junction table between `users` and `events`. It holds the unique `qr_code` generated for a user's ticket and tracking `status` (e.g., 'registered', 'checked-in').
- **`announcements`**: Stores broadcast messages. The `author_id` references the staff member who created the announcement.
- **`timetable`**: Stores schedule entries, mapping subjects to times, days, and rooms.
