import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drag_drop/cloud_service.dart';
import 'package:flutter_drag_drop/user.dart';
import 'package:flutter_drag_drop/auth_parameters.dart';
import 'package:flutter_drag_drop/user_page.dart';

// Authentication service class
class AuthService {

  // Registration activity
  static Future<String?> register(BuildContext context, AuthParameters param) async {
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
  static Future<String?> login(BuildContext context, AuthParameters param) async {
    try {
      // Firebase authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: param.email,
          password: param.password
      );
      MyUser? usr;
      try {
        usr = userList.firstWhere(
              (e) =>
          e.uid == userCredential.user?.uid
        );
      } on StateError catch(e) {
        // User might have been created outside
        // the application, hence it is not accessible.
        logout();
        return '${e.message}: User is private';
      }
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserPage(user: usr!)
          )
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return handleException(e);
    }
    return 'Unknown problem occurred.';
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

