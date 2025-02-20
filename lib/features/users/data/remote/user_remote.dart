import 'package:sqlite/models/user_model.dart';

abstract class UserRemote {
  Future<List<User>> fetchUsers();
}
