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
- Pending Bills: list of unpaid bills with inline pay action ✅
- Payment History: chronological list of paid bills ✅
- Pay Bill: form to pay a specific bill (in progress)
- Create Bill: form to create a new bill (in progress)

## Not Implemented Yet
- Pay Bill and Create Bill forms (Block 3, in progress)
- OData filtering (planned)
- Unit tests (planned)
- Android build (optional bonus)
