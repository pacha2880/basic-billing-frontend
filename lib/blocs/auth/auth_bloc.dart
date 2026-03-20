// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

import 'package:bloc/bloc.dart';

import '../../core/network/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await ApiService.getToken(event.clientId);
      ApiService.setToken(token);
      html.window.sessionStorage['clientId'] = event.clientId.toString();
      emit(AuthAuthenticated(clientId: event.clientId, token: token));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) {
    ApiService.clearToken();
    html.window.sessionStorage.remove('clientId');
    emit(AuthInitial());
  }
}
