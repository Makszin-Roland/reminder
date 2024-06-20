import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder/shared/styled_text.dart';
import 'package:reminder/theme.dart';
import 'package:reminder/utils/utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  final _utils = Utils();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    if (_emailController.text.isEmpty) {
      _utils.messageDialog(context, 'Please enter an email!');
      return true;
    }


    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim()
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: 
        Text('An email is sent to reset Password!')
      ));

      _utils.messageDialog(context, 'Password requirement!\n  - min. 8 character!');

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      //navigatorKey.currentState!.popUntil((route) => route.isFirst);

      // ignore: use_build_context_synchronously
      Utils().errorDialog(context, e.message);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title:  const StyledText('Reset password'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Enter your email and we will send you a password reset link',
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        label: Text('Email')     
                      ),
                      style: const TextStyle(color: Colors.white),
                    ), 
                
                    const SizedBox(height: 30,),
                
                    ElevatedButton.icon(
                      icon: const Icon(Icons.sync),
                      label: const Text('Reset'),
                      style:  ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),  
                      ),
                      onPressed: resetPassword
                    
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      
    );
  }
}

