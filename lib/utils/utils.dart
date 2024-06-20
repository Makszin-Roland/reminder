import 'package:flutter/material.dart';
import 'package:reminder/theme.dart';

class Utils {

  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  showSnackBar(String? text) {
    if ( text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red,);

    messengerKey.currentState
      ?..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void errorDialog(context, String? str) {
    showDialog(
      context: context, 
      builder: (context) { 
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Text(str!),
        );
      }
    );
  }

  void messageDialog(context, String str) {
    showDialog(
        context: context, 
        builder: (context) {
          Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pop(true);
          });
          return AlertDialog(
            backgroundColor: AppColors.buttonColor,
            contentTextStyle: const TextStyle(
              fontSize: 16.0,
              color: Colors.black
            ),
            content: Text(str),
          );
        }
      );
  }
}