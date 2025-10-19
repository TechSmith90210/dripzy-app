import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

//when a register is requested
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

//when a login is request from the ui
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

//logout event
class LogoutRequested extends AuthEvent {}

//user data requested
class UserDataRequested extends AuthEvent {
  final String authToken;

  UserDataRequested({required this.authToken});

  @override
  List<Object?> get props => [authToken];
}
