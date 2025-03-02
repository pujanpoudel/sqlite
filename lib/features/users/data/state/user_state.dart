import 'package:sqlite/features/users/data/model/user_model.dart';

class UserState {
  final bool isLoading;
  final List<User> users;
  final String? error;
  final bool isLoaded;

  UserState(
      {this.isLoading = false,
      this.users = const [],
      this.error,
      this.isLoaded = false});

  UserState copyWith(
      {bool? isLoading, List<User>? users, String? error, bool? isLoaded}) {
    return UserState(
        isLoading: isLoading ?? this.isLoading,
        users: users ?? this.users,
        error: error ?? this.error,
        isLoaded: isLoaded ?? this.isLoaded);
  }
}
