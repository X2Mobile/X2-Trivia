import '../../domain/repositories/user_repository.dart';

final class DataUserRepository implements UserRepository {
  @override
  Future<String> getUser() async {
    return 'user';
  }
}
