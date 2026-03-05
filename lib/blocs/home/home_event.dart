import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHome extends HomeEvent {
  final String id;
  final String token;

  const LoadHome({required this.id, required this.token});

  @override
  List<Object> get props => [id, token];
}
