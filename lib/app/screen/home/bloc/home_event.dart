import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class SignOutEvent extends HomeEvent {
  const SignOutEvent();

  @override
  List<Object> get props => [];
}
