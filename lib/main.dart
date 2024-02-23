

import 'package:flutter/material.dart';
import 'package:notifo/constants/routes.dart';
import 'package:notifo/services/auth/auth_service.dart';
import 'package:notifo/views/login_view.dart';
import 'package:notifo/views/notes_view.dart';
import 'package:notifo/views/register_view.dart';
import 'package:notifo/views/verify_email.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 34, 145, 214)),
          useMaterial3: true,
        ),
        home: const Homepage(),
        routes: {
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const Registerview(),
          notesRoute : (context) => const NotesView(),
          verifyEmailRoute:(context) => const VerifyEmailView(),
        }),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

