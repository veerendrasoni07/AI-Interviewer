
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/model/user.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider() : super(null);

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  void clearUser() {
    state = null;
  }

}

final userProvider = StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());
