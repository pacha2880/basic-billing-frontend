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
- Session persistence: dart:html sessionStorage saves clientId across browser refreshes
- OData: $filter and $orderby built in repositories, passed as Dio queryParameters
- Error extraction order: error → message → detail → title (detail before title to avoid generic HTTP status labels)
- Navigation shell: ShellRoute with NavigationRail (>600px) / NavigationBar (≤600px)
- Unit tests deferred due to time constraints
