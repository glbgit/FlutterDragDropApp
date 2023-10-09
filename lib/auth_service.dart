import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      var usr = MyUser(
        userCredential.user?.uid ?? 'user${userList.length}',
        param.email,
        param.password,
        param.displayName,
      );
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
      var usr = MyUser(
        userCredential.user?.uid ?? '',
        param.email,
        param.password,
        param.displayName,
      );
      if (userList.isEmpty) {
        userList.add(usr);
      } else if (!usr.belongsTo(userList)) {
        userList.add(usr);
      }
    } on FirebaseAuthException catch (e) {
      return handleException(e);
    }
    var usr = userList.firstWhere((e) => e.email == param.email);
    // Navigate to user page
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserPage(user: usr)
        ),
      );
      return null;
    }
    return 'Unknown problem occurred.';
  }

  // Logout activity
  static void logout(BuildContext context) {
    // TODO: Define log out
  }

  // Handle authentication result
  static String handleException(FirebaseAuthException exc) {
    if (exc.code == 'channel-error') {
      return 'Unable to connect to the server.';
    } else if (exc.code == 'invalid-email') {
      return 'The email format is not valid.';
    } else if (exc.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
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

