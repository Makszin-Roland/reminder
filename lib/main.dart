import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/screens/auth/auth_page.dart';
import 'package:reminder/screens/home/home_screen.dart';
import 'package:reminder/services/reminder_store.dart';
import 'package:reminder/theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:reminder/utils/utils.dart';
import 'firebase_options.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => ReminderStore(),
    child: MaterialApp(
      theme: primaryTheme,
      home: const MyApp(),
    ),
  ));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils().messengerKey,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: primaryTheme,
      home: const MainPage()
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder:(context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        } else 
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong!'),);
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const AuthPage();
        }
      },   
    ),
  );
}



