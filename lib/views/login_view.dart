import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          // devtools.log(userCredential.toString());
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/notes/',
                            (route) => false,
                          );
                        }
                        /* 
                        //CATCH ALL ERRORs BLOCK
                        catch (e) {
                          devtools.log('Some error occured....');
                          devtools.log(e.runtimeType);
                          devtools.log(e);
                        }
                        //CATCH SPECIFIC ERROR BLOCK 
                        */
                        on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            devtools.log('User not found');
                          } else if (e.code == 'wrong-password') {
                            devtools.log('Wrong password');
                          } else {
                            devtools.log('Some error occured....');
                            devtools.log(e.code);
                            devtools.log(e.toString());
                          }
                        }
                      },
                      child: const Text('Login')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/register/', (route) => false);
                      },
                      child: const Text('Not registered yet? Register here!'))
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
