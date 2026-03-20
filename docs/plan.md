# BasicBilling Frontend — Development Plan

## Block Status

| Block | Description | Status |
|-------|-------------|--------|
| 0 | Flutter project created, dependencies installed, build passing | ✅ Done |
| 1 | Core setup: models, ApiService, BillsBloc, AuthBloc, routing | ✅ Done |
| 2 | Screen: Pending Bills + inline Pay action | 🔄 Next |
| 3 | Screen: Pay Bill form + confirmation | ⏳ Pending |
| 4 | Screen: Create Bill + Payment History + routing | ⏳ Pending |
| 5 | Polish: Material Design 3, responsive layout, error handling | ⏳ Pending |
| 6 | Delivery: README, cleanup, push to GitHub | ⏳ Pending |
| 7 | Android (optional/fun) | ⏳ Bonus |

## Block 2 — Next steps in order

1. lib/screens/pending_bills_screen.dart
   - Client selector (read from AuthBloc — client already selected on home)
   - On screen load: dispatch LoadPendingBills with current clientId
   - Show loading indicator while BillsBloc is loading
   - Show list of pending bills with columns: Service Type, Billing Period, Amount, Status
   - Each bill has an inline Pay button
   - Pressing Pay dispatches PayBill event to BillsBloc
   - On BillPaymentSuccess: reload the list automatically
   - Show error message if BillsBloc emits BillsError

## Decisions Already Made
- flutter_bloc for state management (not Riverpod or Provider)
- Dio for HTTP (not the http package) — needed for interceptors
- go_router for navigation
- Clients hardcoded in frontend — no GET /clients endpoint needed
- Token obtained per client selection, stored in AuthBloc
- Backend runs on http://localhost:5214
