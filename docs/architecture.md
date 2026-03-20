# BasicBilling Frontend — Architecture Reference

## Project
- Framework: Flutter (web primary, Android optional)
- Language: Dart
- State management: flutter_bloc
- HTTP client: Dio (with JWT interceptor)
- Navigation: go_router
- Design: Material Design 3

## Backend API
- Base URL: http://localhost:5214
- Auth: POST /api/auth/token — body: { clientId: int } — returns JWT token
- All other endpoints require: Authorization: Bearer <token>

## Folder Structure

basic_billing_frontend/
├── lib/
│   ├── main.dart
│   ├── app.dart                        ← MaterialApp + go_router setup
│   ├── core/
│   │   ├── constants/
│   │   │   └── api_constants.dart      ← base URL and endpoint paths
│   │   ├── network/
│   │   │   └── api_service.dart        ← Dio instance + JWT interceptor
│   │   └── theme/
│   │       └── app_theme.dart          ← Material Design 3 theme
│   ├── models/
│   │   ├── bill_model.dart
│   │   ├── payment_history_model.dart
│   │   └── client_model.dart
│   ├── repositories/
│   │   ├── bill_repository.dart
│   │   └── payment_repository.dart
│   ├── blocs/
│   │   ├── auth/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── bills/
│   │   │   ├── bills_bloc.dart
│   │   │   ├── bills_event.dart
│   │   │   └── bills_state.dart
│   │   └── payments/
│   │       ├── payments_bloc.dart
│   │       ├── payments_event.dart
│   │       └── payments_state.dart
│   └── screens/
│       ├── home_screen.dart
│       ├── pending_bills_screen.dart
│       ├── pay_bill_screen.dart
│       ├── create_bill_screen.dart
│       └── payment_history_screen.dart
└── docs/

## Models

### BillModel
- id (int)
- clientId (int)
- serviceType (String): "Water", "Electricity", "Sewer"
- billingPeriod (String): YYYYMM format
- amount (double)
- status (String): "Pending" or "Paid"
- createdAt (DateTime)
- fromJson factory constructor

### PaymentHistoryModel
- billId (int)
- serviceType (String)
- billingPeriod (String)
- amountPaid (double)
- paidAt (DateTime)
- status (String): always "Paid"
- fromJson factory constructor

### ClientModel
- id (int)
- name (String)
- hardcoded list kClients with all 5 clients:
  100 Joseph Carlton, 200 Maria Juarez, 300 Albert Kenny,
  400 Jessica Phillips, 500 Charles Johnson

## API Endpoints Used

GET  /api/clients/{id}/pending-bills    → List<BillModel>
POST /api/payments                      → PaymentHistoryModel
     body: { clientId, serviceType, billingPeriod }
POST /api/bills                         → BillModel
     body: { clientId, serviceType, billingPeriod, amount }
GET  /api/clients/{id}/payment-history  → List<PaymentHistoryModel>
POST /api/auth/token                    → { token: string }
     body: { clientId }

## Key Rules
- Never call the API directly from a screen — always go through a repository
- Never put business logic in screens — use blocs
- JWT token is obtained once on app start or client selection and stored in AuthBloc
- Dio interceptor reads token from AuthBloc and adds it to every request header
- Show loading indicator while waiting for API responses
- Show error message if API call fails
