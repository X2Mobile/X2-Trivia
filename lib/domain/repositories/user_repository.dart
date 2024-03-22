abstract class UserRepository {
  Future<String> getUser();
}

final class UserRepositoryImpl implements UserRepository {
  @override
  Future<String> getUser() async {
    return 'user';
  }
}