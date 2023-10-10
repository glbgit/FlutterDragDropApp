import 'package:flutter/material.dart';
import 'package:flutter_drag_drop/auth_parameters.dart';
import 'auth_service.dart';
import 'user.dart';

// Authentication activity
enum AuthType {
  login,
  register
}

// Main page at app startup
class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.title});

  final String title;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  AuthType _type = AuthType.login;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirm = TextEditingController();
  final _displayName = TextEditingController();

  // Clear text fields
  void _clearFields() {
    _email.clear();
    _password.clear();
    _passwordConfirm.clear();
    _displayName.clear();
  }

  // Switch authentication page
  void _switchToLogin() {
    setState(() {
      _type = AuthType.login;
      _clearFields();
    });
  }

  void _switchToSignup() {
    setState(() {
      _type = AuthType.register;
      _clearFields();
    });
  }

  // Listeners
  void _onPressedSignup() async {
    AuthParameters param = AuthParameters(
        email: _email.text,
        password: _password.text,
        displayName: _displayName.text,
    );
    if (param.confirmPassword(_passwordConfirm.text)) {
      String? issue = await AuthService.register(context, param);
      if (issue == null) {
        setState(() {
          _type = AuthType.login;
          _clearFields();
          }
        );
      }
      _showFeedback(issue);
    } else {
      _showFeedback('Passwords do not match!');
    }
  }

  void _onPressedLogin() async {
    AuthParameters param = AuthParameters(
      email: _email.text,
      password: _password.text,
      displayName: _displayName.text,
    );
    String? issue = await AuthService.login(context, param);
    if (issue != null) {
      _showFeedback(issue);
    } else {
      _clearFields();
    }
  }

  void _showFeedback(String? message) {
    var snackBar = SnackBar(
      content: Text(message??'Operation successfully completed!'),
      duration: const Duration(seconds: 2),
      backgroundColor: message != null
          ? Colors.black
          : Colors.deepPurpleAccent,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      // Login page
      case AuthType.login:
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text('Insert your credentials: '),
                // Email field
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                ),
                // Password field
                TextField(
                  obscureText: true,
                  controller: _password,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                // Button
                ElevatedButton(
                  onPressed: _onPressedLogin,
                  child: const Text('Log in'),
                ),
                // Sign up if not registered
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('First login? '),
                    InkWell(
                      onTap: _switchToSignup,
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Text('Registered users: ${userList.length}'),
              ],
            ),
          ),
        );

      // Register page
      case AuthType.register:
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(widget.title)
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('New account: '),
                // Name field
                TextField(
                  controller: _displayName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter your name',
                  ),
                ),
                // Email field
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                ),
                // Password field
                TextField(
                  obscureText: true,
                  controller: _password,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Choose a password',
                  ),
                ),
                // Password confirmation field
                TextField(
                  obscureText: true,
                  controller: _passwordConfirm,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
                // Button
                ElevatedButton(
                  onPressed: _onPressedSignup,
                  child: const Text('Sign up'),
                ),
                // Sign in if registered
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Registered? '),
                    InkWell(
                      onTap: _switchToLogin,
                      child: Text(
                          'Log in',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor,
                          )
                      ),
                    ),
                  ],
                ),
                Text('Registered users: ${userList.length}'),
              ],
            ),
          ),
        );

      default:
        return const Scaffold(
          body: Center(
            child: Text('ERROR: Unknown page type.'),
          ),
        );
    }
  }
}


