import 'package:task_project/core/models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class RegisterLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserData user;
  AuthSuccess(this.user);
}

class RegisterSuccess extends AuthState {
  final String message;
  RegisterSuccess(this.message);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class RegisterFailure extends AuthState {
  final String error;
  RegisterFailure(this.error);
}
