# 🍽️ Recipe Discovery App

A context-aware Flutter recipe app that suggests meals based on your **time of day** and **GPS location** — with full offline support.

---

## 🐛 Bugs Fixed (from original project)

| # | File | Bug | Fix |
|---|------|-----|-----|
| 1 | `network_info.dart` | `connectivity_plus v5+` returns `List<ConnectivityResult>`, compared against single value — **always returned `false`** → API never called | `.any((r) => r != ConnectivityResult.none)` |
| 2 | `repository_provider.dart` | `Dio()` created without `baseUrl` — all requests went to invalid URLs | `DioClient.create()` sets `baseUrl` via `BaseOptions` |
| 3 | `recipe_model.dart` | `strCategory`, `strArea`, `strInstructions` marked `required` — crashes on `/filter.php` which only returns `id/name/thumb` | All fields made optional with `''` defaults |
| 4 | `recipe_model.dart` | No ingredient parsing — `strIngredient1..20` fields ignored | Added full ingredient loop in `fromJson` |

---

## 🚀 Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Run app
flutter run

# 3. Build APK
flutter build apk --release
```

---

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constants/       # API URLs, country→cuisine map
│   ├── error/           # Exceptions & Failures
│   ├── network/         # Dio client, NetworkInfo
│   ├── services/        # Location, Notifications
│   ├── theme/           # Light/dark theme (Playfair + Nunito fonts)
│   └── utils/           # TimeUtils (meal context), Debouncer
│
├── data/
│   ├── datasources/
│   │   ├── local/       # Hive cache + favorites
│   │   └── remote/      # MealDB API via Dio
│   ├── entities/        # Recipe, Ingredient (pure Dart)
│   ├── models/          # RecipeModel (extends entity, has fromJson/toJson)
│   └── repositories/    # RecipeRepositoryImpl (network-first, cache fallback)
│
└── presentation/
    ├── providers/        # Riverpod: recipes, favorites, theme, search
    ├── screens/          # Home, Detail, Favorites
    └── widgets/          # RecipeCard, ShimmerLoader, EmptyState
```

**Data flow:** `Screen → Provider → Repository → [Remote API | Hive Cache]`

---

## ✨ Features

- **Context-aware** — detects time (breakfast/lunch/dinner) + GPS location → maps to cuisine
- **Offline-first** — Hive caches last API response; always shows something
- **Search** with 500ms debounce
- **Favorites** persisted to Hive
- **Shimmer loading**, Hero animations, scale animations on heart button
- **Dark/Light mode** toggle
- **Pull-to-refresh**
- **Scheduled notifications** at 8am, 2pm, 8pm
- Empty states for no internet, no results, no favorites
