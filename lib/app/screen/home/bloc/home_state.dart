import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState({
    this.userDisplayName,
  });

  final String? userDisplayName;

  HomeState copyWith({String? user}) => HomeState(
        userDisplayName: user,
      );

  @override
  List<Object?> get props => [userDisplayName];
}
