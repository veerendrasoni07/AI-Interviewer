import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/view/screens/home_screen.dart';
import 'package:vapi/vapi.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  VapiClient.platformInitialized.future;
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
    );
  }
}
