import 'package:flutter/material.dart';
import 'package:notifo/constants/routes.dart';
import 'package:notifo/services/auth/auth_Exceptions.dart';
import 'package:notifo/services/auth/auth_service.dart';
import 'package:notifo/utilities/show_error_dialog.dart';

class Registerview extends StatefulWidget {
  const Registerview({super.key});

  @override
  State<Registerview> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Please enter your password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                  await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakpasswordAuthException{
                   await showErrorDialog(
                    context,
                    'weak-password',
                  );
              } on EmailalreadyinuseAuthException{
                  await showErrorDialog(
                    context,
                    'email-already-in-use',
                  );
              } on InvalidcredentialAuthException{
                 await showErrorDialog(
                    context,
                    'invalid-email',
                  );
              } on GenericAuthException{
                  await showErrorDialog(
                    context,
                    'Failed to  Register',
                  );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already registered? Login here!'),
          )
        ],
      ),
    );
  }
}
