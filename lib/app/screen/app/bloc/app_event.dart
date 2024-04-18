import 'package:equatable/equatable.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

final class UserRequestedEvent extends AppEvent {
  const UserRequestedEvent();
}
