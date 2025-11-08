import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

IklanCard(String title, String description, String img, Color color, String btn) {
  return Center(
    child: Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 200,
        width: 440,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                      Text(description, style: TextStyle(fontSize: 14),),
                    ],
                  ), 
                ]
              ),
            ),
            Image.asset(img, width: 150,)
          ],
        ),
      ),
    ),
  );
}
