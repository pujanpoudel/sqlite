import 'package:sqlite/features/users/data/remote/user_remote.dart';
import 'package:sqlite/features/users/data/remote/user_remote_impl.dart';
import 'package:sqlite/features/users/data/user_repo.dart';
import 'package:sqlite/features/users/data/model/user_model.dart';
import 'package:sqlite/services/connectivity_service.dart';
import 'local/user_local.dart';
import 'local/user_local_impl.dart';

// final userRepositoryImplProvider = Provider((ref) => UserRepositoryImpl());
final ConnectivityService _connectivityService = ConnectivityService();

class UserRepositoryImpl extends UserRepository {
  @override
  Future<List<User>> fetchUsersRepo() async {
    bool isConnected = await _connectivityService.isConnected();
    if (isConnected) {
      UserRemote userRemote = UserRemoteImpl();
      return await userRemote.fetchUsers();
    } else {
      UserLocal userLocal = UserLocalImpl();
      return await userLocal.fetchUsers();
    }
  }
}
