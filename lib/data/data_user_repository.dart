import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/user_repository.dart';
import 'exceptions/login_exceptions.dart';

final class DataUserRepository<T> extends UserRepository {
  @override
  Stream<User?> getUser() async* {
    try {
      yield FirebaseAuth.instance.currentUser;
    } catch (error) {
      if (error is FirebaseAuthException) {
        throw AuthenticationException.firebase(error.message);
      } else {
        throw AuthenticationException.unknown();
      }
    }
  }

  @override
  Stream<User> loginUser(String email, String password) async* {
    try {
      var credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      yield credentials.user!;
    } catch (error) {
      if (error is FirebaseAuthException) {
        throw AuthenticationException.firebase(error.message);
      } else {
        throw AuthenticationException.unknown();
      }
    }
  }

  @override
  Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      if (error is FirebaseAuthException) {
        throw AuthenticationException.firebase(error.message);
      } else {
        throw AuthenticationException.unknown();
      }
    }
  }

  @override
  Stream<User> createUser(String? name, String email, String password) async* {
    try {
      var credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var user = credentials.user!;
      yield* user
          .updateDisplayName(name)
          .then((value) => FirebaseAuth.instance.currentUser!)
          .asStream();
    } catch (error) {
      if (error is FirebaseAuthException) {
        throw AuthenticationException.firebase(error.message);
      } else {
        throw AuthenticationException.unknown();
      }
    }
  }
}
