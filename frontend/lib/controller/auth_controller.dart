import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/global_variable.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future<bool> signUp({
    required String fullname,
    required String email,
    required String password,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/sign-up"),
        body: jsonEncode({
          "fullname": fullname,
          "email": email,
          "password": password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        final data = jsonDecode(response.body);

        print(data);
        final userJson = jsonEncode(data['user']);
        await preferences.setString('token', data['token']);
        await preferences.setString('user', userJson);
        ref.read(userProvider.notifier).setUser(userJson);
        print("done");
        return true;
      }
      else{
        throw Exception('Failed to create account');
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/sign-in'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        final data = jsonDecode(response.body);
        print(response.body);
        final token = data['token'];
        final user = data['user'];
        final userJson = jsonEncode(user);
        await preferences.setString('user', userJson);
        await preferences.setString('token', token);
        ref.read(userProvider.notifier).setUser(userJson);
        return true;
      } else {
        print(response.body);
        throw Exception('Failed to create account');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
