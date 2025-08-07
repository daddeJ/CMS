# CMS
Contact Management System

## 🎯 Project Overview

**Tech Stack:**
- Backend: .NET 8 Web API + Entity Framework Core + SQL Server
- Frontend: Flutter (Android/iOS)
- DevOps: Docker, GitHub

**Key Features:**
- CRUD operations for contacts
- Image upload and storage
- RESTful API design
- Cross-platform mobile app
- Docker containerization

## 📂 Project Structure
```
CMS/
├── mobile-app/              # Flutter frontend
├── shared/                  # Contains Shared.csproj (contracts, DTOs, etc.)
├── backend/
│   ├── CMS.sln              # Solution file includes shared and services
│   ├── services/
│   │   ├── auth-service/
│   │   │   └── src/
│   │   └── contact-service/
│   │       └── src/
│   ├── tests/
│       ├── AuthService.Tests/
│       └── ContactService.Tests/
├── docker/
│   └── sql/init.sql
├── docker-compose.yml
└── README.md
```
```
lib/
├── core/                          # Shared core utilities
│   ├── config/
│   │   └── api_config.dart        # Dynamic API base URL config
│   ├── constants/
│   │   └── app_constants.dart     # App-wide constants
│   ├── errors/
│   │   └── exceptions.dart        # Custom exceptions
│   └── utils/
│       └── logger.dart            # Logging utility
│
├── data/                          # Handles data fetching/saving
│   ├── datasources/
│   │   ├── local/
│   │   │   └── auth_local_data_source.dart    # SQLite/shared prefs
│   │   └── remote/
│   │       ├── auth_remote_data_source.dart
│   │       └── contact_remote_data_source.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   └── contact_model.dart
│   └── repositories_impl/
│       ├── auth_repository_impl.dart
│       └── contact_repository_impl.dart
│
├── domain/                        # Business logic layer
│   ├── entities/
│   │   ├── user.dart
│   │   └── contact.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   └── contact_repository.dart
│   └── usecases/
│       ├── login_user.dart
│       ├── register_user.dart
│       ├── fetch_contacts.dart
│       ├── add_contact.dart
│       ├── update_contact.dart
│       └── delete_contact.dart
│
├── presentation/                  # UI & state management
│   ├── splash/
│   │   └── splash_page.dart
│   │
│   ├── api_config/
│   │   ├── pages/
│   │   │   └── api_config_page.dart
│   │   └── cubit/
│   │       └── api_config_cubit.dart
│   │
│   ├── auth/
│   │   ├── pages/
│   │   │   ├── login_page.dart
│   │   │   └── register_page.dart
│   │   └── cubit/
│   │       └── auth_cubit.dart
│   │
│   ├── contact/
│   │   ├── pages/
│   │   │   ├── contact_list_page.dart
│   │   │   ├── add_contact_page.dart
│   │   │   └── update_contact_page.dart
│   │   └── cubit/
│   │       └── contact_cubit.dart
│
├── routes/
│   └── app_router.dart            # App-level navigation
│
├── main.dart
└── injection_container.dart       # DI setup using GetIt

```