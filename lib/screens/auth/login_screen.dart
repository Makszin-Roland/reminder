import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:reminder/main.dart';
import 'package:reminder/screens/home/home_screen.dart';
import 'package:reminder/services/firestore_service.dart';
import 'package:reminder/services/reminder_store.dart';
import 'package:reminder/shared/styled_text.dart';
import 'package:reminder/theme.dart';
import 'package:reminder/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onClickSignUp;


  const LoginScreen({
    super.key,
    required this.onClickSignUp,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final formKeyLogin = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledText('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKeyLogin,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text('Email')     
                ),
                style: const TextStyle(color: Colors.white),
                validator: validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),  

              const SizedBox(height: 30,),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  label: Text('Password')     
                ),
                style: const TextStyle(color: Colors.white),
                validator:(value) {
                  if( value == null || value.length < 8) {
                    return 'Password should be minimum 8 character';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
              ), 

              const SizedBox(height: 30,),

              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Login'),
                style:  ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),  
                ),
                onPressed: logIn, 
    
              ),

              const SizedBox(height: 1,),

              RichText(
                text: TextSpan(
                  text: 'Create an account?  ',
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickSignUp,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.buttonColor
                      )
                    ),
                  ],
                ),
              )
            ],
          
          ),
        ),
      ),
    );
  }

  Future logIn() async {
    final isValid = formKeyLogin.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim()
        );

    } on FirebaseAuthException catch (e) {
      
      //print(e);
      // ignore: use_build_context_synchronously
      Utils().errorDialog(context, e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  String? validateEmail(String? email) {
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isValid = emailRegExp.hasMatch(email ?? '');
    if (!isValid){
      return 'Please enter a valid email';
    }
    return null;
  }

}