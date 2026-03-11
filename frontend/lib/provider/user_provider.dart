import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider() : super(null);

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  void creditChange() async {
    state = state!.copyWith(credits: state!.credits - 1);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', state!.toJson());
  }

  void clearUser() {
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserProvider, User?>(
  (ref) => UserProvider(),
);
