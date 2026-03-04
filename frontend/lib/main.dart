import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/auth_manager_provider.dart';
import 'package:frontend/view/authentication/login_screen.dart';
import 'package:frontend/view/main_screen.dart';
import 'package:get/get.dart';
import 'package:vapi/vapi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  VapiClient.platformInitialized.future;
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 280),
      home:
          ref.watch(authManagerProvider) == AuthStatus.authenticated
              ? MainScreen()
              : LoginScreen(),
    );
  }
}
