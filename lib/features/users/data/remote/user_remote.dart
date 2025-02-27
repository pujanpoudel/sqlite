import 'package:sqlite/features/users/data/model/user_model.dart';

abstract class UserRemote {
  Future<List<User>> fetchUsers();
}
