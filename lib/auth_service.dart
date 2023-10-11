import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_drag_drop/cloud_service.dart';
import 'package:flutter_drag_drop/user.dart';
import 'package:flutter_drag_drop/auth_parameters.dart';

// Authentication service class
class AuthService {

  // Registration activity
  static Future<String?> register(AuthParameters param) async {
    try {
      // Firebase registration
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: param.email,
          password: param.password
      );

      // Create user
      var usr = MyUser(
        userCredential.user?.uid ?? 'user${userList.length}',
        param.email,
        param.password,
        param.displayName,
      );

      // Add user
      CloudService.add(usr);
      userList.add(usr);

      return null;
    } on FirebaseAuthException catch (e) {
      return handleException(e);
    }
  }

  // Login activity
  static Future<String?> login(AuthParameters param) async {
    try {
      // Firebase authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: param.email,
          password: param.password
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return handleException(e);
    }
  }

  // Logout activity
  static void logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  // Handle authentication result
  static String handleException(FirebaseAuthException exc) {
    if (exc.code == 'channel-error') {
      return 'Unable to connect to the server.';
    } else if (exc.code == 'invalid-email') {
      return 'The email format is not valid.';
    } else if (exc.code == 'invalid-login-credentials') {
      return 'Invalid login credentials.';
    } else if (exc.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    } else if (exc.code == 'user-disabled') {
      return 'User is not available.';
    } else if (exc.code == 'user-not-found') {
      return 'No user found for the given email.';
    } else if (exc.code == 'wrong-password') {
      return 'Incorrect password.';
    } else if (exc.code == 'weak-password') {
      return 'Password is too weak, must be at least 6 characters.';
    } else {
      return 'Unknown problem occurred.';
    }
  }
}

