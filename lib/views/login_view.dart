import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import '../utilities/dialogs/error_dialog.dart';

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
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bgImage.png'),
              fit: BoxFit.cover,
              opacity: 0.05)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: Image.asset('assets/logo.png'),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
          ),
          SizedBox(
            width: 300,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(10),
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      context.read<AuthBloc>().add(
                            AuthEventLogin(email, password),
                          );
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
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            /*child: const Text(
                'Not registered yet? Register here!',
                style: TextStyle(color: Colors.black54),
              )*/
            child: RichText(
              text: const TextSpan(
                  style: TextStyle(fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Not registered yet?',
                        style: TextStyle(color: Colors.black54)),
                    TextSpan(
                        text: ' Register here!',
                        style: TextStyle(color: Colors.green))
                  ]),
            ),
          )
        ],
      ),
    ));
  }
}
