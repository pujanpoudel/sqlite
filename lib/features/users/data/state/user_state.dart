import 'package:sqlite/features/users/data/model/user_model.dart';

class UserState {
  final bool isLoading;
  final List<User> users;
  final String? error;

  UserState({
    this.isLoading = false,
    this.users = const [],
    this.error,
  });

  UserState copyWith({bool? isLoading, List<User>? users, String? error}) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      error: error ?? this.error,
    );
  }
}
