import 'package:sqlite/features/users/data/model/user_model.dart';

abstract class UserLocal {
  Future<List<User>> fetchUsers();
}
