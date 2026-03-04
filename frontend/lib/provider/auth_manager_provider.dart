
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/view/authentication/login_screen.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus{
  unknown,
  unauthenticated,
  authenticated;
}

class AuthManagerProvider extends StateNotifier<AuthStatus>{
  Ref ref;
  AuthManagerProvider(this.ref):super(AuthStatus.unknown){
    init();
  }


  void init()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? user = preferences.getString('user');
    if(user != null) ref.read(userProvider.notifier).setUser(user);
    state = token == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
  }

  void setAuthenticated(){
    state = AuthStatus.authenticated;
  }

  Future<void> logout({required BuildContext context}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ref.read(userProvider.notifier).clearUser();
    state = AuthStatus.unauthenticated;
    Get.offAll(() => const LoginScreen());
  }
}

final authManagerProvider = StateNotifierProvider<AuthManagerProvider,AuthStatus>((ref)=> AuthManagerProvider(ref));
