import 'package:sqlite/features/users/data/remote/user_remote.dart';
import 'package:sqlite/features/users/data/remote/user_remote_impl.dart';
import 'package:sqlite/features/users/data/user_repo.dart';
import 'package:sqlite/models/user_model.dart';

class UserRepositoryImpl extends UserRepository {
  @override
  Future<List<User>> fetchUsersRepo() async {
    UserRemote userRemote = UserRemoteImpl();
    return await userRemote.fetchUsers();
  }
}
