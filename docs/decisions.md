# BasicBilling Frontend — Decision Log

- Framework: Flutter web (Android optional bonus)
- State management: flutter_bloc (Bloc pattern, not Cubit)
- HTTP: Dio with interceptor for automatic JWT header injection
- Navigation: go_router
- Design: Material Design 3 (Flutter native)
- Models: manual fromJson constructors (no build_runner or freezed)
- Clients: hardcoded in ClientModel as kClients constant
- Auth flow: select client → call POST /api/auth/token → store token in AuthBloc → Dio interceptor injects it automatically
- serviceType sent as string to match backend JsonStringEnumConverter
- billingPeriod format: YYYYMM (6 digits, no dashes)
- Backend base URL: http://localhost:5214 (development only)

I will manually copy two PDF files into this folder:
- requirements-frontend.pdf (primary reference for this project)
- requirements-backend.pdf (secondary reference, already implemented)
