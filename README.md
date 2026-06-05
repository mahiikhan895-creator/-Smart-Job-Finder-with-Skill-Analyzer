# 🚀 Smart Job Finder & Skill Analyzer

A Flutter-based recruitment management application that helps users discover job opportunities, analyze required skills, receive training recommendations, track applications, and access data offline through local storage and synchronization.

---

## 📋 Project Overview

Smart Job Finder & Skill Analyzer is a mobile application built with Flutter that integrates job listings, skill analysis, application tracking, and analytics into a single platform. The application follows a clean architecture approach using Provider for state management, Repository Pattern for data handling, and Hive for offline-first functionality.

---

## ✨ Key Features

- Browse remote job listings from a live API
- Search and filter jobs by title, company, location, and employment type
- View detailed job information including salary, skills, and description
- Analyze required skills from job postings
- Get recommended training resources and courses
- Track job applications with status updates
- Access cached data offline using Hive
- Automatic synchronization when internet connection is restored
- Real-time connectivity monitoring
- Analytics dashboard with charts and insights
- Lazy loading and pagination for improved performance

---

## 📂 Project Structure

```text
lib/
├── models/
│   ├── job_model.dart
│   ├── job_model.g.dart
│   ├── skill_model.dart
│   ├── skill_model.g.dart
│   ├── application_model.dart
│   └── application_model.g.dart
│
├── services/
│   ├── job_api_service.dart
│   ├── skill_api_service.dart
│   ├── connectivity_service.dart
│   └── skill_extractor_service.dart
│
├── repositories/
│   ├── job_repository.dart
│   └── skill_repository.dart
│
├── database/
│   └── local_database.dart
│
├── providers/
│   ├── job_provider.dart
│   ├── skill_provider.dart
│   └── analytics_provider.dart
│
├── screens/
│   ├── job_listing/
│   ├── job_detail/
│   ├── skill_analysis/
│   ├── application_tracking/
│   └── analytics/
│
├── widgets/
│   ├── job_card.dart
│   ├── shimmer_card.dart
│   ├── connectivity_banner.dart
│   ├── search_bar_widget.dart
│   └── filter_chips.dart
│
├── utils/
│   └── app_theme.dart
│
└── main.dart
```

---

## 🌐 APIs Used

### API 1 – Job Listings

**Provider:** Remotive Jobs API

**Endpoint**

```text
https://remotive.com/api/remote-jobs
```

**Authentication**

```text
No authentication required
```

**Data Retrieved**

- Job Title
- Company Name
- Location
- Employment Type
- Salary Information
- Job Description
- Skills / Tags

---

### API 2 – Skills & Training Recommendations

**Provider:** DataMuse API + Internal Skill Mapping

**Endpoint**

```text
https://api.datamuse.com/words
```

**Authentication**

```text
No authentication required
```

**Data Retrieved**

- Skill Name
- Skill Category
- Difficulty Level
- Recommended Course
- Learning Provider

---

## 🏗️ Architecture & Design Patterns

| Pattern | Purpose |
|----------|----------|
| Repository Pattern | Separates data access from business logic |
| Provider | State management across the application |
| Service Layer | Handles API calls and utility services |
| Local-First Architecture | Provides offline functionality using Hive |
| Singleton Pattern | Ensures a single database instance |
| Clean Architecture | Improves maintainability and scalability |

---

## ⚙️ Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter 3.x | Cross-platform mobile development |
| Dart 3.x | Programming language |
| Provider | State management |
| Hive | Local database and caching |
| Hive Flutter | Flutter integration for Hive |
| HTTP | REST API communication |
| FL Chart | Analytics and data visualization |
| Shimmer | Loading placeholders |
| Connectivity Plus | Internet connectivity monitoring |
| Intl | Date and time formatting |

---

## 🔄 Offline Support

The application follows an offline-first approach.

### Features

- Job listings are cached locally using Hive
- Application data remains available offline
- Previously loaded jobs can be viewed without internet access
- Automatic synchronization occurs when connectivity is restored
- Duplicate records are prevented during synchronization

---

## 📱 Application Modules

### 1. Jobs Module

- Browse job opportunities
- Search jobs instantly
- Apply filters
- Pagination and lazy loading
- Pull-to-refresh support

### 2. Job Details Module

- Detailed job information
- Company information
- Salary details
- Required skills
- Full job description

### 3. Skill Analysis Module

- Extract skills from job descriptions
- Categorize skills as:
  - Technical Skills
  - Soft Skills
  - Other Skills
- Recommend learning resources

### 4. Application Tracking Module

Manage application statuses:

- Applied
- Interview
- Rejected
- Accepted

### 5. Analytics Dashboard

Provides:

- Application statistics
- Job insights
- Skill distribution charts
- Progress tracking

---

## ✅ Functional Requirements Coverage

| Requirement | Status |
|------------|---------|
| Job Listing API Integration | ✔ Completed |
| Skill Analysis API Integration | ✔ Completed |
| Search Functionality | ✔ Completed |
| Filter Functionality | ✔ Completed |
| Pagination / Lazy Loading | ✔ Completed |
| Job Details Screen | ✔ Completed |
| Skill Analysis Screen | ✔ Completed |
| Application Tracking | ✔ Completed |
| Analytics Dashboard | ✔ Completed |
| Offline Data Storage | ✔ Completed |
| Connectivity Monitoring | ✔ Completed |
| Auto Synchronization | ✔ Completed |

---

## 🚀 Installation Guide

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio or VS Code
- Android Emulator or Physical Device

### Clone Repository

```bash
git clone https://github.com/your-username/smart_job_finder.git
cd smart_job_finder
```

### Install Dependencies

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

### Build Release APK

```bash
flutter build apk --release
```

---

## 🍎 iOS Configuration

Add the following to:

```text
ios/Runner/Info.plist
```

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

## 🚀 Future Enhancements

- User Authentication
- Resume Upload and Parsing
- AI-Based Job Recommendations
- Push Notifications
- Cloud Data Synchronization
- Bookmark and Favorite Jobs
- Advanced Analytics Reports

---

## 👩‍💻 Author

**Maheen Hassan Khan**

BS Computer Science  
University of Wah

---

## 📄 License

This project is developed for educational and learning purposes.
