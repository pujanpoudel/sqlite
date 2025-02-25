import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/model/user_model.dart';
import 'data/user_repo_impl.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<List<User>> {
  final Ref _ref;
  UserNotifier(this._ref) : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final users =
          await _ref.read(userRepositoryImplProvider).fetchUsersRemote();
      state = users;
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> refreshUsers() async {
    await _initialize();
  }
}
