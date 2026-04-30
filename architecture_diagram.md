# Software Architecture Diagram

The Smart Campus Operations System utilizes **Clean Architecture** combined with **Feature-First Project Structuring**.

```mermaid
flowchart TD
    %% Define Subgraphs for the Architecture Layers
    subgraph Presentation Layer ["Presentation Layer (UI & State)"]
        UI["Flutter UI (Widgets/Pages)"]
        State["Riverpod Providers/Notifiers"]
    end

    subgraph Domain Layer ["Domain Layer (Business Logic)"]
        UseCases["Use Cases (e.g., RegisterEvent, GetSchedule)"]
        Entities["Entities (e.g., User, Event, Timetable)"]
        RepoInterfaces["Repository Interfaces (I_EventRepository)"]
    end

    subgraph Data Layer ["Data Layer (Data Sources & Models)"]
        RepoImpl["Repository Implementations (EventRepositoryImpl)"]
        Models["Data Models (e.g., EventModel, UserModel)"]
        
        subgraph Data Sources ["Data Sources"]
            LocalDB["Local DataSource (SQLite via sqflite)"]
            RemoteAPI["Remote DataSource (API via Dio)"]
        end
    end
    
    subgraph Core & External ["Core & External Dependencies"]
        Router["GoRouter (Navigation)"]
        Firebase["Firebase Cloud Messaging"]
        Map["flutter_map & geolocator"]
        Scanner["mobile_scanner & qr_flutter"]
    end

    %% Define the data flow
    UI -->|Triggers Actions| State
    State -->|Calls| UseCases
    State -->|Updates UI with| Entities
    
    UseCases -->|Requires| RepoInterfaces
    UseCases -->|Returns| Entities
    
    RepoImpl -.->|Implements| RepoInterfaces
    RepoImpl -->|Converts Models to| Entities
    RepoImpl -->|Fetches Data from| LocalDB
    RepoImpl -->|Fetches Data from| RemoteAPI
    
    RemoteAPI -->|Returns/Uses| Models
    LocalDB -->|Returns/Uses| Models
    
    %% Connections to external modules
    UI --> Router
    State --> Scanner
    State --> Map
    RemoteAPI --> Firebase
```

### Architecture Breakdown:

1. **Presentation Layer**: 
   - Handles everything the user interacts with. UI is built with standard Flutter widgets.
   - **Riverpod** is used to separate UI from logic. It listens to changes in the data and triggers UI rebuilds.

2. **Domain Layer**:
   - Contains the core business logic independent of frameworks. 
   - **Entities**: Pure Dart classes representing real-world objects in the app (e.g., `Event`, `User`).
   - **Use Cases**: Encapsulate specific business rules (e.g., logic to verify if an event has capacity before registering).
   - **Repository Interfaces**: Abstract contracts defining what data operations are possible without dictating how they are performed.

3. **Data Layer**:
   - Responsible for data retrieval and storage.
   - **Repository Implementations**: Fulfill the domain layer's interfaces. Decides whether to fetch data from the local cache (`SQLite`) or a remote API.
   - **Models**: Extensions of Domain Entities that include JSON/Map serialization for databases and APIs.
   - **Data Sources**: Handle raw data operations (e.g., SQL queries, HTTP requests).
