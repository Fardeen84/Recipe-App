#  Context-Aware Recipe Discovery App

A production-grade Flutter application that intelligently suggests recipes based on **time of day** and **user location**, with a robust **offline-first architecture** and automated **CI/CD pipeline**.

---

##  Live Features

*  **Time-based Suggestions**

    * Morning → Breakfast 
    * Afternoon → Lunch 
    * Evening → Dinner 

*  **Location-based Recipes**

    * Detects user country via GPS
    * Maps country → cuisine (e.g., India → Indian food)

*  **Smart Search**

    * Debounced search (500ms) to reduce API calls

*  **Offline-First**

    * Cached recipes via Hive
    * Favorites available without internet
    * Graceful fallback when network fails

*  **Favorites**

    * Save/remove recipes
    * Persisted locally

*  **Scheduled Notifications**

    * 8 AM → Breakfast suggestion
    * 2 PM → Lunch suggestion
    * 8 PM → Dinner suggestion

*  **UI/UX Enhancements**

    * Shimmer loading states
    * Hero animations (list → detail)
    * Animated favorite button
    * Pull-to-refresh
    * Dark / Light mode

---

##  Bugs Fixed (from original project)

| # | File                       | Issue                                            | Fix                        |
| - | -------------------------- | ------------------------------------------------ | -------------------------- |
| 1 | `network_info.dart`        | connectivity_plus v5 returns List → always false | Used `.any()` check        |
| 2 | `repository_provider.dart` | Dio without baseUrl                              | Introduced `DioClient`     |
| 3 | `recipe_model.dart`        | Required fields crash on filter API              | Made fields optional       |
| 4 | `recipe_model.dart`        | Ingredients not parsed                           | Added dynamic parsing loop |

---

##  Architecture (Clean Architecture + Riverpod)

```
Presentation → Providers → Repository → DataSources → API / Local DB
```

### Folder Structure

```
lib/
├── core/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── services/
│   ├── theme/
│   └── utils/
│
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   └── remote/
│   ├── entities/
│   ├── models/
│   └── repositories/
│
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

---

##  Tech Stack

* **Flutter**
* **Riverpod (State Management)**
* **Dio (Networking)**
* **Hive (Local Storage)**
* **Geolocator + Geocoding**
* **flutter_local_notifications**
* **GitHub Actions (CI/CD)**

---

##  Setup Instructions

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Build release APK
flutter build apk --release
```

---

##  Environment Setup (CI/CD)

Secrets required in GitHub:

```
KEYSTORE_BASE64
KEYSTORE_PASSWORD
KEY_ALIAS
KEY_PASSWORD
```

---

##  CI/CD Pipeline

On every push to `main`:

✔ Runs `flutter analyze`
✔ Runs `flutter test`
✔ Builds release APK
✔ Uploads APK to GitHub Releases

 Path:

```
.github/workflows/main.yml
```

---

##  APK Download

 Go to:

```
GitHub → Releases → Download APK
```

---

##  Key Engineering Decisions

* **Offline-first approach** for better UX
* **Separation of concerns** via Clean Architecture
* **Parallel vs lazy API loading optimization**
* **Graceful permission handling**
* **Network fallback strategy**

---

## Future Improvements

* Pagination (infinite scroll)
* Firebase push notifications
* Recipe recommendations (AI-based)
* Unit & widget test coverage expansion

---

## Author

**Fardeen Khan**
Flutter Developer


