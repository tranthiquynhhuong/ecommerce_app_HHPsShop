import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/CategoryBloc.dart';
import 'package:grocery_shop_flutter/bloc/ThemeBloc.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/views/Home.dart';
import 'package:grocery_shop_flutter/views/SignIn.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  final _themeBloc=ThemeBloc();


  checkAuth() {
    UserBloc().checkAuth().then((bool isAuth) async {
      if (isAuth == false) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => new SignIn()));
        return;
      }
      await CategoryBloc().fetchCates();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => new MyHomePage()));
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _themeBloc.getThemeValuesSF();
    // TODO: implement afterFirstLayout
    checkAuth();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: double.maxFinite,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }
}

