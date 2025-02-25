import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqlite/features/users/data/remote/remote/user_remote_impl.dart';
import 'package:sqlite/features/users/data/user_repo.dart';
import 'package:sqlite/features/users/data/model/user_model.dart';
import 'package:sqlite/services/connectivity_service.dart';
import 'package:sqlite/services/database_service.dart';
import 'remote/local/user_local.dart';
import 'remote/local/user_local_impl.dart';
import 'remote/remote/user_remote.dart';

final userRepositoryImplProvider = Provider((ref) => UserRepositoryImpl());
final ConnectivityService _connectivityService = ConnectivityService();
final DatabaseService _databaseService = DatabaseService.instance;

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

  Future<void> addToLocalDatabase(List<User> users) async {
    await Future.wait(users.map((item) => _databaseService.addUserFromRemote(
        item.name, item.age, item.gender, item.email)));
  }

  Future<void> addUser(List<User> users) async {
    await Future.wait(users.map((item) => _databaseService.addUser(
        item.name, item.age, item.gender, item.email)));
  }

  Future<void> updateUser(List<User> users) async {
    await Future.wait(users.map((item) => _databaseService.updateUser(
        item.id.toString(), item.name, item.age, item.gender, item.email)));
  }

  Future<List<User>> fetchUsersRemote() async {
    UserRemoteImpl remoteRepo = UserRemoteImpl();
    List<User> users = await remoteRepo.fetchUsers();
    return users;
  }
}
