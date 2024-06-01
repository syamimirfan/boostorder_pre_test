import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    labelStyle:  TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
       fontSize: 20,
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder (
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: Color.fromARGB(255, 95, 86, 162), width: 2,),
    ),
    errorBorder: OutlineInputBorder (
       borderRadius: BorderRadius.all(Radius.circular(30.0)),
       borderSide: BorderSide(color: Color.fromARGB(255, 95, 86, 162), width: 2),
    ), 

     focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: Color.fromARGB(255, 95, 86, 162), width: 2)
    ),
);