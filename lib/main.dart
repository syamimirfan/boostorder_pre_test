import 'package:boostorder_pre_test/view/category_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/cart_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
      ],
      child: const MyApp(),
    ),
  );
}

 class MyApp extends StatefulWidget {
   const MyApp({super.key});
 
   @override
   State<MyApp> createState() => _MyAppState();
 }
  
 class _MyAppState extends State<MyApp> {


   @override
   void initState() {
    super.initState();
   }


   @override
   Widget build(BuildContext context) {
        
  return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 95, 86, 162),
      ),
      home:const CartCategory(),
    );
   }
 }