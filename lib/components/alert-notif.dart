import 'package:flutter/material.dart';

Notification(BuildContext context, String title, String content, String routes){
  return showDialog(context: context, builder: (context) => AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      ElevatedButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text("Cancel")),
      TextButton(
        onPressed: (){
          Navigator.pop(context);
          Navigator.pushNamed(context, routes);
        }, 
        child: Text("Oke")
      )
    ],
  ));
}