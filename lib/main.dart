import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/views/SignIn.dart';
import 'package:grocery_shop_flutter/views/SplashScreen.dart';
import 'views/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Grocery Store',
      theme: ThemeData(
        primaryColor: Colors.amber,
        fontFamily: 'JosefinSans',
      ),
      home: SplashScreen(),
    );
  }
}