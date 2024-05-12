import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Stream<User?> getUser();

  Stream<User> loginUser(String email, String password);

  Future<void> logoutUser();

  Stream<User> createUser(String? name, String email, String password);
}
