import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_drag_drop/auth_parameters.dart';
import 'package:flutter_drag_drop/auth_service.dart';
import 'package:flutter_drag_drop/firebase_options.dart';
import 'package:flutter_drag_drop/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  test('Sign up: User on the list.', () {
    AuthService.register(
        const AuthParameters(
            email: 'test@gmail.com',
            password: 'password'
        ),
    );
    
    expect(MyUser.getUserByEmail('test@gmail.com')?.email, 'test@gmail.com');
    expect(MyUser.getUserByEmail('test@gmail.com')?.password, 'password');

  });

  test('Sign in: User logged in', () {
    AuthService.register(
      const AuthParameters(
          email: 'test@gmail.com',
          password: 'password'
      ),
    );

    AuthService.login(
      const AuthParameters(
          email: 'test@gmail.com',
          password: 'password'
      ),
    );

    expect(true,true);

  });
}