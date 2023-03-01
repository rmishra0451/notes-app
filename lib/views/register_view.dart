import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/routes.dart';
import '../dialogs/error_dialog.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

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
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          devtools.log(userCredential.toString());
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            // devtools.log('Choose a stronger password');
                            await showErrorDialog(
                                context, 'Choose a stronger password');
                          } else if (e.code == 'email-already-in-use') {
                            devtools.log(e.code);
                            await showErrorDialog(
                                context, 'User already exists');
                          } else if (e.code == 'invalid-email') {
                            // devtools.log('This is an invalid email address');
                            await showErrorDialog(
                                context, 'Invalid email address');
                          } else {
                            // devtools.log('Some other error occured');
                            // devtools.log(e.code);
                            await showErrorDialog(context, 'Error- ${e.code}');
                          }
                        } catch (e) {
                          await showErrorDialog(context, e.toString());
                        }
                      },
                      child: const Text('Register')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (route) => false);
                      },
                      child: const Text('Already registered? Login here!'))
                ],
              );
            default:
              return const Text('Loading....');
          }
        },
      ),
    );
  }
}
