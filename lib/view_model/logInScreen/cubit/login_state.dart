part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginDone extends LoginState {
  LoginDone();
}

class LoginError extends LoginState {
  String error;

  LoginError(this.error);
}

class LoginPasswordIsShown extends LoginState {}
