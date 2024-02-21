

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notifo/firebase_options.dart';
import 'package:notifo/views/login_view.dart';
import 'package:notifo/views/register_view.dart';
import 'package:notifo/views/verify_email.dart';




void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 22, 19, 27)),
        useMaterial3: true,
      ),
      home: const Homepage(),
      routes: {
        'login' : (context) => const LoginView(),
          'register' : (context) => const Registerview(),
        }
    ), 
    );
}
class Homepage extends StatelessWidget {
  const Homepage({super.key});

   @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
              ),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            
            case ConnectionState.done:
           final user = FirebaseAuth.instance.currentUser;
           print(user);
           if(user != null){
            if(user.emailVerified){
             print('Email is verified');
            }
           else{
            print(user);
            return const VerifyEmailView();
           }
           }else{
            return const LoginView();
           }
           return const Text('Done');
          //  print(user);
          //  if(user?.emailVerified?? false){
          //   // print("You are a verified user");
          // return const Text("Done");
          //  }else{
          //   // print("You need to verify your email first");
          //  return const VerifyEmailView();
          //  }
        default:
          return const CircularProgressIndicator();
          }
        },
      );
  }
}

