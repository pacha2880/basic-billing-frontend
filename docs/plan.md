# BasicBilling Frontend — Development Plan

## Block Status

| Block | Description | Status |
|-------|-------------|--------|
| 0 | Flutter project created, dependencies installed, build passing | ✅ Done |
| 1 | Core setup: models, ApiService, BillsBloc, AuthBloc, routing | ✅ Done |
| 2 | Screen: Pending Bills + inline Pay action + Payment History | ✅ Done |
| 3 | Screen: Pay Bill form + Create Bill form | 🔄 Next |
| 4 | Polish: Material Design 3, responsive layout, error handling | ⏳ Pending |
| 5 | OData filtering + unit tests | ⏳ Pending |
| 6 | Delivery: README, cleanup, push to GitHub | ⏳ Pending |
| 7 | Android (optional/fun) | ⏳ Bonus |

## Block 3 — Next steps in order

1. lib/screens/pay_bill_screen.dart — full form implementation
2. lib/screens/create_bill_screen.dart — full form implementation
3. Add CreateBillEvent to BillsBloc if needed

## Decisions Already Made
- flutter_bloc for state management (not Riverpod or Provider)
- Dio for HTTP (not the http package) — needed for interceptors
- go_router for navigation
- Clients hardcoded in frontend — no GET /clients endpoint needed
- Token obtained per client selection, stored in AuthBloc
- Backend runs on http://localhost:5214
