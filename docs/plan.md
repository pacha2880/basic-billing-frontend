# BasicBilling Frontend — Development Plan

## Block Status

| Block | Description | Status |
|-------|-------------|--------|
| 0 | Flutter project created, dependencies installed, build passing | ✅ Done |
| 1 | Core setup: models, ApiService, BillsBloc, AuthBloc, routing | ✅ Done |
| 2 | Screen: Pending Bills + inline Pay action + Payment History | ✅ Done |
| 3 | Screen: Pay Bill form + Create Bill form + error handling | ✅ Done |
| 4 | Polish: Material Design 3, responsive layout, navigation | ✅ Done |
| 5 | OData filtering and sorting on list screens | ✅ Done |
| 6 | Delivery: README, cleanup, push to GitHub | ⏳ Next |
| 7 | Android (optional/fun) | ⏳ Bonus |

## Decisions Already Made
- flutter_bloc for state management (not Riverpod or Provider)
- Dio for HTTP (not the http package) — needed for interceptors
- go_router for navigation
- Clients hardcoded in frontend — no GET /clients endpoint needed
- Token obtained per client selection, stored in AuthBloc
- Backend runs on http://localhost:5214
- Error messages extracted from backend response 'error' field
- OData implemented on Pending Bills and Payment History screens
- Unit tests deferred due to time constraints
