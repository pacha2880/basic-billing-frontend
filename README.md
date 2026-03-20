# BasicBilling Frontend

Flutter web application for managing utility bill payments (water, electricity, sewer).

## Tech Stack
- Flutter (web)
- flutter_bloc for state management (Bloc pattern)
- Dio for HTTP requests with JWT interceptor
- go_router for navigation
- Material Design 3

## Requirements
- Flutter SDK installed
- Backend API running on http://localhost:5214
- See BasicBilling API repository to run the backend first

## How to Run (web)
flutter run -d chrome

## How to Build (web)
flutter build web

## Screens implemented
- Home: client selector with JWT authentication
- Pending Bills: list of unpaid bills with inline Pay button
- Pay Bill: form to pay a specific bill with validation
- Create Bill: form to create a new bill with validation
- Payment History: chronological list of paid bills

## Features
- Client selection with automatic JWT token retrieval
- View pending bills per client
- Pay bills inline from the pending list or via the Pay Bill form
- Create new bills with full validation
- View payment history per client
- Friendly error messages from API responses
- Session persistence on browser refresh

## Not Implemented
- OData filtering on list screens (planned)
- Unit tests (planned)
- Android build (optional bonus)

## Notes
- serviceType is sent as string (Water, Electricity, Sewer)
- billingPeriod format is YYYYMM (6 digits, no dashes)
- JWT token is obtained automatically when a client is selected
