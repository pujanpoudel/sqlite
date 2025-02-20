import 'package:sqlite/apiClient/api_client.dart';
import 'package:sqlite/features/users/data/remote/user_remote.dart';
import 'package:sqlite/models/user_model.dart';

class UserRemoteImpl extends UserRemote {
  @override
  Future<List<User>> fetchUsers() async {
    ApiClient _apiClientObj = ApiClient();
    List<User> users = await _apiClientObj.getUsers();
    return users;
  }
}
