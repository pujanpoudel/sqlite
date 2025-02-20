import 'package:sqlite/models/user_model.dart';

abstract class UserRepository {
  Future<List<User>> fetchUsersRepo();
}
