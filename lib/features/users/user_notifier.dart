import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite/features/users/data/state/user_state.dart';
import 'package:sqlite/features/users/data/user_repo_impl.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserState> {
  final UserRepositoryImpl _userRepo = UserRepositoryImpl();

  UserNotifier() : super(UserState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      state = state.copyWith(
        isLoading: true,
      );
      final users = await _userRepo.fetchUsersRepo();
      state = state.copyWith(isLoading: false, users: users);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Failed to load users");
      print("Error fetching users: $e");
    }
  }

  Future<void> refreshUsers() async {
    await _initialize();
  }
}
