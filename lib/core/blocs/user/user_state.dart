import 'package:task_project/core/models/user.dart';

abstract class UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserData> users;
  UserLoaded(this.users);
}

class UpadetWalletBalance extends UserState {
  final String message;
  UpadetWalletBalance(this.message);
}

class UpadetWalletBalanceError extends UserState {
  final String error;
  UpadetWalletBalanceError(this.error);
}

class UserError extends UserState {
  final String error;
  UserError(this.error);
}
