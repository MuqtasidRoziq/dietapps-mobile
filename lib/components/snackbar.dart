import 'package:flutter/material.dart';

ShowAlert(BuildContext context, String title, Color color){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))
      )
    )
    );
}