# BasicBilling Frontend

Flutter web application for managing utility bill payments (water, electricity, sewer).

## Tech Stack
- Flutter (web)
- flutter_bloc for state management
- Dio for HTTP requests with JWT interceptor
- go_router for navigation
- Material Design 3

## Requirements
- Flutter SDK installed
- Backend API running on http://localhost:5214
- Run the backend first: see BasicBilling API repository

## How to Run (web)
flutter run -d chrome

## How to Build (web)
flutter build web

## Screens
- Home: client selector with authentication
- Pending Bills: list of unpaid bills with inline pay action (in progress)
- Pay Bill: form to pay a specific bill (pending)
- Create Bill: form to create a new bill (pending)
- Payment History: chronological list of paid bills (pending)

## Not Implemented Yet
- Full screen implementations (Block 2-4, in progress)
- OData filtering (planned)
- Unit tests (planned)
- Android build (optional bonus)
