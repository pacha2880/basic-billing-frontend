// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'app.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';

void main() {
  final authBloc = AuthBloc();

  final savedClientId = html.window.sessionStorage['clientId'];
  if (savedClientId != null) {
    authBloc.add(AuthLoginRequested(int.parse(savedClientId)));
  }

  runApp(App(authBloc: authBloc));
}
