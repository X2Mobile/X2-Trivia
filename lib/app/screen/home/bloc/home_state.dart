import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState({
    this.user,
  });

  final String? user;

  HomeState copyWith({String? user}) => HomeState(
        user: user,
      );

  @override
  List<Object?> get props => [user];
}
