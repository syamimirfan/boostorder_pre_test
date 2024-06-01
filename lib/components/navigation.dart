import 'package:flutter/material.dart';

// to go back to current page by click specific button
void nextScreenPop(context) {
 Navigator.pop(context);    
}

//to remove the current page and go to other page
void nextScreenRemoveUntil(context, page) {
  Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context) => page), (route) => false);
}

//to replace the place and go to front page after the current page
void nextScreenReplacement(context, page) {
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

//to push the page 
void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
