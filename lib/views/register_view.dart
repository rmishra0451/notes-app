import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import '../constants/routes.dart';
import '../dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        body: Column(
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
                  final navigator = Navigator.of(context);

                  try {
                    await AuthService.firebase().createUser(
                      email: email,
                      password: password,
                    );
                    await AuthService.firebase().sendEmailVerification();
                    navigator.pushNamed(verifyEmailRoute);
                  } on WeakPasswordAuthException {
                    await showErrorDialog(
                        context, 'Choose a stronger password');
                  } on EmailAlreadyInUseAuthException {
                    await showErrorDialog(context, 'User already exists');
                  } on InvalidEmailAuthException {
                    await showErrorDialog(context, 'Invalid email address');
                  } on GenericAuthException {
                    await showErrorDialog(context, 'Some error occured');
                  }
                },
                child: const Text('Register')),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(loginRoute, (route) => false);
          },
          /* child: const Text(
              'Already registered? Login here!',
              style: TextStyle(color: Colors.black54),
            )*/
          child: RichText(
            text: const TextSpan(
                style: TextStyle(fontSize: 15),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Already registered?',
                      style: TextStyle(color: Colors.black54)),
                  TextSpan(
                      text: ' Login here!',
                      style: TextStyle(color: Colors.green))
                ]),
          ),
        )
      ],
    ));
  }
}
