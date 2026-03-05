import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;

  const ProfileLoaded({required this.name, required this.email});

  @override
  List<Object?> get props => [name, email];
}
