import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite/features/users/data/model/user_model.dart';
import 'package:sqlite/features/users/data/user_repo_impl.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<List<User>> {
  final UserRepositoryImpl _userRepo = UserRepositoryImpl();

  UserNotifier() : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final users = await _userRepo.fetchUsersRepo();
      state = users;
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  /// Manually refresh users
  Future<void> refreshUsers() async {
    await _initialize();
  }
}
