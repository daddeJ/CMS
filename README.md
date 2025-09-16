# Contacts App

## Project Overview

The **Contacts App** is a cross-platform mobile application designed to manage and store contact information efficiently. It follows a **Clean Architecture** approach, separating the application into layers for maintainability, scalability. The app supports **online API integration** for a seamless user experience.

### Key Features
* Add, edit, and delete contacts
* Search and paginate contact lists
* Add profile images for contacts
* Connect to a backend API via configurable IP
* Modular architecture for easy future feature expansion

## Technologies Used

### Frontend (Mobile App)
* **Flutter** – Cross-platform mobile framework
* **Dart** – Programming language for the app logic
* **flutter_bloc** – State management with the BLoC pattern
* **image_picker** – Capture or select images for contacts
* **shared_preferences** – Local storage for user settings
* **http** – REST API communication

### Backend API
* **.NET 8 (ASP.NET Core Web API)** – RESTful backend service
* **C#** – Backend application logic
* **Entity Framework Core** – ORM for database interactions
* **AutoMapper** – Object mapping between DTOs and entities
* **SQL Server** – Database for storing contacts
* **Swagger** – API documentation and testing

### General Tools
* **Docker** – Containerized deployment of the backend
* **Git** – Version control
* **Postman** – API testing
* **VS Code / Android Studio** – Development environment

## Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────┐
│           Presentation Layer        │
│        (Flutter UI & BLoC)          │
├─────────────────────────────────────┤
│           Application Layer         │
│       (Use Cases & Services)        │
├─────────────────────────────────────┤
│            Domain Layer             │
│      (Entities & Repositories)      │
├─────────────────────────────────────┤
│         Infrastructure Layer        │
│    (API Client & Local Storage)     │
└─────────────────────────────────────┘
```

## Getting Started

### Prerequisites
* Flutter SDK (3.0+)
* Dart SDK
* Android Studio / VS Code
* .NET 8 SDK (for backend)
* SQL Server / SQLite

### Contact Management System Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/daddeJ/CMS.git
   cd CMS
   ```

### Backend API Setup

1. **Using Docker Compose (Recommended)**
   ```bash
   docker compose build --no-cache
   docker-compose up -d
   ```
   This will automatically:
    - Build the API container
    - Set up the database (SQL Server/SQLite)
    - Run database init.sql to create DB and table
    - Start the API on port 5000

2. **Stop the services**
   ```bash
   docker-compose down
   ```

### Mobile app Setup 
1. **Change Director to Contact App**
   ```bash
    cd mobile/contacts_app
   ```
1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the app**
   ```bash
   flutter run
   ```
   
## Features

### Auth Service
- **Register**: For new user registration with email, password, first name, and last name
- **Login**: For user authentication with email and password

### Contact Service
- **Create Contact**: Add new contacts with name, phone, email, and profile image
- **View Contacts**: Browse through contacts with pagination support
- **Edit Contact**: Update existing contact information
- **Delete Contact**: Remove contacts from the system

### Configuration
- **API Configuration**: Set custom backend server IP address
- **Image Handling**: Camera capture or gallery selection for profile pictures

## Configuration

### API Configuration
The app allows users to configure the backend API endpoint:

1. On first launch, enter your server IP address
2. The app automatically formats it as `http://[IP]:5000`
3. Settings are saved locally for future sessions

## API Endpoints

### Authentication
- `POST /auth-api/api/Auth/register` - Register new user
  #### Body:
  ```json
  {
    "email": "string",
    "password": "string",
    "firstName": "string",
    "lastName": "string"
  }
  ```

- `POST /auth-api/api/Auth/login` - User login
  #### Body:
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```

### Contacts *Requires Authorization*
> **Note**: All contact endpoints require a valid JWT token from the auth service. Include the token in the `Authorization` header as `Bearer {token}`.

- `GET /contact-api/api/Contacts` - Get all contacts (with pagination) 
- `GET /contact-api/api/Contacts/{contactid}` - Get contact by ID 
- `POST /contact-api/api/Contacts` - Create new contact 
  #### Body:
  ```json
  {
    "name": "string",
    "email": "string",
    "phoneNumber": "number",
    "profilePicture": "image_url"
  }
  ```

- `PUT /contact-api/api/Contacts/{id}` - Update contact 
  #### Body:
  ```json
  {
    "name": "string",
    "email": "string",
    "phoneNumber": "number",
    "profilePicture": "image_url"
  }
  ```

- `DELETE /contact-api/api/Contacts/{contactId}` - Delete contact 
- `POST /contact-api/api/Contacts/{contactId}/images` - Upload image 
- `GET /contact-image/uploads/contacts/{contactId}/{imageName}` - Get contact image 

#### Authorization Header Example:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```


## Project Structure
```
CMS/
├── backend/                                    # All backend services and API gateway
│   ├── api-gateway/                            # Entry point for all API requests; routes calls to the right microservice
│   ├── services/                               # Individual microservices
│   │   ├── auth-service/                       # Handles authentication, registration, JWT issuance
│   │   └── contact-service/                    # CRUD operations for contacts
│   └── CMS.sln                                 # Visual Studio solution file for backend projects
│
├── docker/                                     # Docker-related configs and SQL scripts
│   └── sql/
│       └── init.sql                            # Script to initialize ContactDB schema and seed data
│
├── mobile/                                     # Flutter mobile application
│   └── contacts_app/                           # Full mobile app codebase
│
├── shared/                                     # Shared .NET libraries for backend microservices
│   ├── Common/                                 # Shared utilities, constants, and helpers
│   └── Contracts/                              # Shared models, DTOs, and interfaces between services
│
├── .env                                        # Environment variables (DB connection, JWT secrets, etc.)
├── .gitignore                                  # Ignore build outputs, credentials, and unnecessary files
├── build-shared.sh                             # Script to build the shared DLL for backend
├── docker-compose.yml                          # Spins up DB + all microservices in Docker containers
├── init-db.sh                                  # Runs init.sql against the database container
└── README.md                                   # Project documentation and setup instructions
```

## Mobile App Project Structure
```
contacts-app/
lib/
├── core/                                       # Shared core utilities across the mobile app
│   ├── config/
│   │   └── api_config.dart                     # Handles dynamic API base URL config (e.g., IP change)
│   ├── constants/
│   │   └── app_constants.dart                  # Centralized constant values for the app
│   ├── errors/
│   │   └── exceptions.dart                     # Custom exception classes for error handling
│   └── utils/
│       └── logger.dart                         # Centralized logging utility
│
├── data/                                       # Data layer - fetches and stores data
│   ├── datasources/
│   │   ├── local/
│   │   │   └── auth_local_data_source.dart     # Manages local authentication data (SQLite/SharedPrefs)
│   │   └── remote/
│   │       ├── auth_remote_data_source.dart    # Handles login/register API calls
│   │       └── contact_remote_data_source.dart # Handles contact CRUD API calls
│   ├── models/
│   │   ├── user_model.dart                     # Data model for a User
│   │   └── contact_model.dart                  # Data model for a Contact
│   └── repositories_impl/
│       ├── auth_repository_impl.dart           # Auth repository implementation (local + remote)
│       └── contact_repository_impl.dart        # Contact repository implementation (local + remote)
│
├── domain/                                     # Business logic layer (Entities + Use Cases)
│   ├── entities/
│   │   ├── user.dart                           # Core User entity (business model)
│   │   └── contact.dart                        # Core Contact entity (business model)
│   ├── repositories/
│   │   ├── auth_repository.dart                # Contract for Auth repository
│   │   └── contact_repository.dart             # Contract for Contact repository
│   └── usecases/                               # Application-specific actions
│       ├── login_user.dart                     # Login use case
│       ├── register_user.dart                  # Register use case
│       ├── fetch_contacts.dart                  # Retrieve contact list use case
│       ├── add_contact.dart                     # Add a new contact use case
│       ├── update_contact.dart                  # Update existing contact use case
│       └── delete_contact.dart                  # Delete a contact use case
│
├── presentation/                               # UI layer + state management (Bloc/Cubit)
│   ├── splash/
│   │   └── splash_page.dart                    # Splash screen - checks auth state and loads config
│   │
│   ├── api_config/
│   │   ├── pages/
│   │   │   └── api_config_page.dart             # Page to set/change API server IP address
│   │   └── cubit/
│   │       └── api_config_cubit.dart            # State management for API config
│   │
│   ├── auth/
│   │   ├── pages/
│   │   │   ├── login_page.dart                  # Login screen UI
│   │   │   └── register_page.dart               # Registration screen UI
│   │   └── cubit/
│   │       └── auth_cubit.dart                  # State management for authentication flow
│   │
│   ├── contact/
│   │   ├── pages/
│   │   │   ├── contact_list_page.dart           # Displays contact list
│   │   │   ├── add_contact_page.dart            # Add contact form
│   │   │   └── update_contact_page.dart         # Edit contact form
│   │   └── cubit/
│   │       └── contact_cubit.dart               # State management for contact CRUD
│
├── routes/
│   └── app_router.dart                         # Central navigation setup for the app
│
├── main.dart                                   # App entry point
└── injection_container.dart                    # Dependency injection setup (GetIt)
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

# Known Limitations / TODOs

## Fixed Port Configuration
- **API Gateway** runs on port **5000**
- **Auth Service** runs on port **5001**
- **Contact Service** runs on port **5002**
- These ports are currently **hardcoded** and must remain available for the services to run correctly.

## Local Development Only
- The current setup is intended **only for local development environments**.

## Network Requirements
- The mobile device and API services must be connected to the **same local network** for communication.
- The API's **IP address** must be retrieved and configured in the mobile application for successful requests.
## APK Location
- The built APK can be found at:  
  `mobile/apk/flutter-apk`
## TODOs
- Make port configuration **dynamic** via environment variables.
- Add **production-ready** deployment support.
- Improve **network configuration handling** for mobile devices.


## Future Enhancements

- [ ] Contact groups and categories
- [ ] Import/Export contacts (CSV, vCard)
- [ ] Contact synchronization with cloud services
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Contact sharing functionality
- [ ] Backup and restore features
