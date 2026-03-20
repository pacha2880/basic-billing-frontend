class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://localhost:5214';

  // API endpoints
  static const String authToken = '/api/auth/token';
  static const String pendingBills = '/api/clients';
  static const String paymentHistory = '/api/clients';
  static const String bills = '/api/bills';
  static const String payments = '/api/payments';
}
