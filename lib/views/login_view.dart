import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import '../dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(
          children: [
            TextField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email here',
                  prefixIcon: Icon(Icons.email_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  )),
              controller: _email,
            ),
            TextField(
              autocorrect: false,
              enableSuggestions: false,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password here',
                  prefixIcon: Icon(Icons.lock),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  )),
              controller: _password,
            ),
            TextButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(10)),
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    await AuthService.firebase()
                        .logIn(email: email, password: password);
                    final user = AuthService.firebase().currentUser;
                    // devtools.log(userCredential.toString());
                    if (user?.isEmailVerified == true) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        notesRoute,
                        (route) => false,
                      );
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (route) => false,
                      );
                    }
                  } on UserNotFoundAuthException {
                    await showErrorDialog(
                      context,
                      'User not found',
                    );
                  } on WrongPasswordAuthException {
                    await showErrorDialog(
                      context,
                      'Incorrect password',
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      'Authetication Error',
                    );
                  }
                },
                child: const Text('Login')),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text('Not registered yet? Register here!'))
          ],
        ));
  }
}
