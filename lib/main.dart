import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_drag_drop/user.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'auth_page.dart';

void main() {
  initApp();
  runApp(const FlutterDragDrop());
}

class FlutterDragDrop extends StatelessWidget {
  const FlutterDragDrop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drag Drop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthPage(title: 'Welcome'),
    );
  }
}

void initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MyUser.getUsers();
}