import 'package:sqlite/features/users/data/model/user_model.dart';

abstract class UserRepository {
  Future<List<User>> fetchUsersRepo();
}
