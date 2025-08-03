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
