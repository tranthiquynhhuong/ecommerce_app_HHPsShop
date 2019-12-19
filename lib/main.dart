import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/views/SplashScreen.dart';
import 'bloc/ThemeBloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeBloc = ThemeBloc();

    return StreamBuilder(
      stream: themeBloc.observableTheme,
      initialData: false,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Grocery Store',
          theme: snapshot.data?ThemeData.dark():ThemeData(
            primaryColor: Colors.amber,
            fontFamily: 'JosefinSans',
          ),
          home: SplashScreen(),
        );
      }
    );
  }
}