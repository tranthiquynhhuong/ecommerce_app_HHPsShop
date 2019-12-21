import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/views/SplashScreen.dart';
import 'bloc/ThemeBloc.dart';
import 'bloc/UserBloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AfterLayoutMixin {
  final _themeBloc = ThemeBloc();
  final _userBloc = UserBloc();

  @override
  void afterFirstLayout(BuildContext context) async {
    await _userBloc.getAutoLoginValuesSF();
    await _themeBloc.getThemeValuesSF();
    // TODO: implement afterFirstLayout
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _themeBloc.observableTheme,
      initialData: false,
      builder: (context, snapshot) {
        if(!snapshot.hasData|| snapshot.data == null) return Container(color: Colors.red,);
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