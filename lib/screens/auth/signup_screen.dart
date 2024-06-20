import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reminder/main.dart';
import 'package:reminder/shared/styled_text.dart';
import 'package:reminder/theme.dart';
import 'package:reminder/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onClickSignUp;

  const SignUpScreen({
    super.key,
    required this.onClickSignUp,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _password2Controller = TextEditingController();
final formKeySignUp = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledText('Sign up'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKeySignUp,
          child: Center(
            child: SingleChildScrollView(
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
              
                  TextFormField(
                    controller: _password2Controller,
                    decoration: const InputDecoration(
                      label: Text('Password')     
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator:(value) {
                      if( value != _passwordController.text) {
                        return 'Passwords arent equal';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                  ), 
              
                  const SizedBox(height: 30,),
              
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('Sign Up'),
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),  
                    ),
                    onPressed: singUp, 
                  
                  ),
              
                  const SizedBox(height: 1,),
              
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account?  ',
                      children: [
                        TextSpan(
                          text: 'Login',
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
        ),
      ),
    );
  }

  Future singUp() async {
    final isValid = formKeySignUp.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(),)
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim()
        );
      
    } on FirebaseAuthException catch (e) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      // ignore: use_build_context_synchronously
      Utils().errorDialog(context, e.message);

    }
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