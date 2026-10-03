# Intellipaat Learning Dashboard App

A production-grade, native **iOS application** built with **Swift & SwiftUI** following clean architecture (MVVM + Repository Pattern), reactive state management, offline-first local persistence, and automated unit testing.

---

## 1. Architecture

The application is structured using **MVVM (Model-View-ViewModel)** with the **Repository Pattern** to ensure strict separation of concerns, complete testability, and clear boundaries between presentation, business logic, and data layers:

```text
┌────────────────────────────────────────────────────────┐
│                   SwiftUI Presentation                 │
│  (LoginView, CourseDashboardView, CourseDetailsView)   │
└───────────────────────────┬────────────────────────────┘
                            │ User Actions / Observation
                            ▼
┌────────────────────────────────────────────────────────┐
│                    View Layer (MVVM)                   │
│ (LoginViewModel, CourseDashboardViewModel, DetailsVM)  │
└───────────────────────────┬────────────────────────────┘
                            │ Requests / State Updates
                            ▼
┌────────────────────────────────────────────────────────┐
│                    Repository Layer                    │
│           (AuthRepository, CourseRepository)           │
└─────────────┬────────────────────────────┬─────────────┘
              │                            │
              ▼                            ▼
┌───────────────────────────┐┌───────────────────────────┐
│     Remote Data Source    ││     Local Data Source     │
│  (MockRemoteDataSource /  ││  (CourseLocalDataSource / │
│       courses.json)       ││       LocalStorage)       │
└───────────────────────────┘└───────────────────────────┘
```

### Layer Breakdown
- **Presentation (Views)**: Lightweight SwiftUI views responsible solely for UI layout, state observation, and navigation via `NavigationStack`.
- **ViewModels**: Manage screen state (`@MainActor`, `ObservableObject`), input validation, and asynchronous calls to repositories.
- **Domain / Business Logic**: Pure, isolated business logic (`CourseProgressCalculator`) independent of UI or frameworks, enabling bulletproof unit testing.
- **Repositories**: Coordinate remote fetching and local cache fallback, isolating the UI from network and storage implementation details.
- **Data Sources**: Modular remote API clients and local file-backed JSON persistent storage.

---

## 2. Offline Support & Caching Strategy

The app implements an **offline-first repository policy**:

```text
                  CourseRepository.getCourses()
                                │
                        Try Remote Request
                                │
            ┌───────────────────┴───────────────────┐
            │ Success                               │ Failure / Offline
            ▼                                       ▼
     Save to Local Cache                     Check Local Cache
            │                                       │
            ▼                                ┌──────┴──────┐
     Return Remote Data                      │ Cache Found │ Cache Empty
                                             ▼             ▼
                                       Return Cached   Throw Network
                                          Courses          Error
```

1. **Successful Remote Requests**: Automatically cache the latest course catalogue and lesson states to persistent storage.
2. **Offline Fallback**: When the device is offline or the network request fails, `CourseRepository` seamlessly loads cached data without interrupting the user experience.
3. **Progress Persistence**: Marking lessons as completed dynamically recalculates progress and updates local storage.

---

## 3. Security Considerations

For production deployments:
- **Authentication Credentials & Tokens**: Sensitive tokens (Access Tokens, Refresh Tokens, Session Keys) must **never** be stored in plaintext `UserDefaults`. They must be stored in the **iOS Keychain** using `kSecClassGenericPassword` with `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`.
- **Transport Security**: All API traffic must use HTTPS / TLS 1.3 with Certificate and Public Key Pinning to prevent Man-in-the-Middle (MITM) attacks.
- **Token Lifecycle**: Automatic token refresh flows via HTTP interceptors and proactive session revocation on logout.

---

## 4. Scaling for 1 Million Users & Hundreds of Courses

To scale this application for large production userbases:
1. **Server-Side Pagination & Cursor-Based Streaming**: Implement cursor pagination (`/courses?limit=20&cursor=...`) so clients lazily load courses as they scroll.
2. **Global CDN & Edge Caching**: Distribute course metadata and media assets via Cloudflare / AWS CloudFront edge caches.
3. **Database Indexing & Read Replicas**: Index database columns (`user_id`, `course_id`, `enrollment_status`) with read replicas to handle massive read throughput.
4. **Client-Side Cache Invalidation & Differential Sync**: Utilize HTTP `ETag` and `If-Modified-Since` headers or WebSocket/Server-Sent Events (SSE) for incremental delta updates.
5. **Observability & Crash Reporting**: Integrate OpenTelemetry, Datadog APM, and Firebase Crashlytics for proactive monitoring.

---

## 5. Android Implementation Comparison

The clean architecture pattern maps directly to modern Android development:

| iOS (Swift / SwiftUI) | Android (Kotlin / Jetpack Compose) |
| :--- | :--- |
| **SwiftUI Declarative Views** | Jetpack Compose `@Composable` |
| **Swift Concurrency (`async/await`)** | Kotlin Coroutines & `Flow` |
| **SwiftUI `ViewModel` (`@MainActor`)** | Android Architecture `ViewModel` (`viewModelScope`) |
| **Repository Pattern** | Repository Pattern (`Clean Architecture`) |
| **LocalStorage / SwiftData** | Room Database / Jetpack DataStore |
| **XCTest Suite** | JUnit 5, MockK & Espresso |

The core flow remains identical: `Compose UI` $\rightarrow$ `ViewModel` $\rightarrow$ `Repository` $\rightarrow$ `Remote/Local DataSources`.

---

## 6. How to Run the Project

1. Open `Intellipaat_App.xcodeproj` in Xcode (Xcode 15+ / 16 / 17).
2. Select any iPhone Simulator (e.g., **iPhone 17 Pro** or **iPhone 15**).
3. Press **Cmd + R** to run the app.
4. Press **Cmd + U** to run all automated unit tests.

### Demo Credentials:
- **Email**: `test@test.com`
- **Password**: `password`
- *(Or tap the **"Use Demo Credentials"** button on the Login screen)*
