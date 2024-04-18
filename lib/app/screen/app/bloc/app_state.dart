import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppState extends Equatable {
  const AppState({
    this.user,
  });

  final User? user;

  AppState copyWith({User? user}) => AppState(user: user);

  @override
  List<Object?> get props => [];
}
