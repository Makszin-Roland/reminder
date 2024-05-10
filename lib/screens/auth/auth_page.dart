import 'package:flutter/material.dart';
import 'package:reminder/screens/auth/login_screen.dart';
import 'package:reminder/screens/auth/signup_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin 
      ? LoginScreen(onClickSignUp: toggle) 
      : SignUpScreen(onClickSignUp: toggle);
  
  void toggle() => setState(() => isLogin =!isLogin);
}