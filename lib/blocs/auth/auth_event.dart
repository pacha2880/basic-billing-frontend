import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final int clientId;

  const AuthLoginRequested(this.clientId);

  @override
  List<Object> get props => [clientId];
}

class AuthLogoutRequested extends AuthEvent {}
