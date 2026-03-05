import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String id;
  final String token;

  const Authenticated({required this.id, required this.token});

  @override
  List<Object> get props => [id, token];
}

class Unauthenticated extends AuthState {}

class AuthSkipped extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
