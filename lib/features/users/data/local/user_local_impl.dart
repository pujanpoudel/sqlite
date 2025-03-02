import 'package:sqlite/features/users/data/local/user_local.dart';
import 'package:sqlite/features/users/data/model/user_model.dart';
import 'package:sqlite/services/database_service.dart';

final DatabaseService _databaseService = DatabaseService.instance;

class UserLocalImpl extends UserLocal {
  @override
  Future<List<User>> fetchUsers() async {
    return await _databaseService.getUser();
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

  Future<void> deleteUser(List<User> users) async {
    await Future.wait(
        users.map((item) => _databaseService.deleteUser(item.id)));
  }
}
