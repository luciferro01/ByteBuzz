import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
    snackBarAnimationStyle: AnimationStyle(
      curve: Curves.bounceOut,
      duration: const Duration(seconds: 2),
      reverseCurve: Curves.bounceIn,
      reverseDuration: const Duration(milliseconds: 500),
    ),
  );
}

String getNameFromEmail(String email) {
  return email.split('@')[0];
}
