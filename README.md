# BasicBilling Frontend

Flutter web application for managing utility bill payments (water, electricity, sewer).

## Tech Stack
- Flutter (web)
- flutter_bloc for state management (Bloc pattern)
- Dio for HTTP requests with JWT interceptor
- go_router for navigation
- Material Design 3
- OData query parameters for filtering and sorting

## Requirements
- Flutter SDK installed
- Backend API running on http://localhost:5214
- See BasicBilling API repository to run the backend first

## How to Run (web)
flutter run -d chrome

## How to Build (web)
flutter build web

## Screens
- Home: client selector with JWT authentication
- Pending Bills: list of unpaid bills with OData filtering/sorting + inline Pay button
- Pay Bill: form to pay a specific bill with validation
- Create Bill: form to create a new bill with validation
- Payment History: chronological list of paid bills with OData filtering/sorting

## Features
- Client selection with automatic JWT token retrieval
- View pending bills per client with filter by service type and sort by amount or period
- Pay bills inline from the pending list or via the Pay Bill form
- Create new bills with full validation
- View payment history with filter by service type and sort by date or amount
- OData query parameters sent to backend for server-side filtering and sorting
- Friendly error messages from API responses
- Session persistence on browser refresh
- Responsive layout: NavigationRail on desktop, BottomNavigationBar on mobile
- Dark mode support

## OData Examples (sent to backend)
Filter by service type:
GET /api/clients/100/pending-bills?$filter=serviceType eq 'Water'

Sort by amount descending:
GET /api/clients/100/pending-bills?$orderby=amount desc

Filter payment history:
GET /api/clients/100/payment-history?$filter=serviceType eq 'Electricity'

Sort by date:
GET /api/clients/100/payment-history?$orderby=paidAt desc

## Not Implemented
- Unit tests (deferred due to time constraints)
- Android build (optional bonus)
