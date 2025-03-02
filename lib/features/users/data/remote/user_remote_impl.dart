import 'package:sqlite/apiClient/api_client.dart';
import 'package:sqlite/features/users/data/model/user_model.dart';
import 'package:sqlite/features/users/data/remote/user_remote.dart';

class UserRemoteImpl extends UserRemote {
  @override
  Future<List<User>> fetchUsers() async {
    ApiClient apiClient = ApiClient();
    List<User> users = await apiClient.getUsers();
    return users;
  }
}
