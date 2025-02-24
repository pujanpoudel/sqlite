import 'package:sqlite/models/user_model.dart';

abstract class UserLocal {
  Future<List<User>> fetchUsers();
}
