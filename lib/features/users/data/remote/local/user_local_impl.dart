import 'package:sqlite/features/users/data/remote/local/user_local.dart';
import 'package:sqlite/features/users/data/model/user_model.dart';
import 'package:sqlite/services/database_service.dart';

final DatabaseService _databaseService = DatabaseService.instance;

class UserLocalImpl extends UserLocal {
  @override
  Future<List<User>> fetchUsers() async {
    return await _databaseService.getUser();
  }
}
