import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/CategoryBloc.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/components/AppTools.dart';
import 'package:grocery_shop_flutter/repositories/UserRepository.dart';
import 'package:grocery_shop_flutter/views/Home.dart';
import 'package:grocery_shop_flutter/views/SignUp.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _userBloc = new UserBloc();
  BuildContext context;
  UserRepository userRepository = new UserRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.amber,
          ),
          SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new SizedBox(
                  height: 100.0,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      appTextField(
                        isPassword: false,
                        textHint: "Email",
                        textIcon: Icons.email,
                        controller: email,
                      ),
                      new SizedBox(
                        height: 40.0,
                      ),
                      appTextField(
                          isPassword: true,
                          textHint: "Mật khẩu",
                          textIcon: Icons.lock,
                          controller: password),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50.0, right: 50.0, top: 30.0),
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      appButton(
                        btnTxt: "Đăng nhập",
                        onBtnclicked: verifyLogin,
                        btnPadding: 20,
                        btnColor: Theme.of(context).primaryColor,
                      ),
                      new GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new SignUp()));
                        },
                        child: new Text(
                          "Bạn chưa có tài khoản? Đăng ký tại đây",
                          style: new TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  verifyLogin() async {
    if (email.text == "") {
      showSnackbar("Vui lòng không để trống Email !", scaffoldKey);
      return;
    } else if (!email.text.contains("@")) {
      showSnackbar("Email không hợp lệ !", scaffoldKey);
      return;
    } else if (password.text == "") {
      showSnackbar("Vui lòng không để trống mật khẩu !", scaffoldKey);
      return;
    } else {
      displayProgressDialog(context);
      bool response = await _userBloc.loginUser(
          email.text, generateMd5(password.text).toString());
      if (response == true) {
        await CategoryBloc().fetchCates();
        closeProgressDialog(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new MyHomePage()));
      } else {
        closeProgressDialog(context);
        showSnackbar("ĐĂNG NHẬP THẤT BẠI\n*Tài khoản đăng nhập không đúng ! \n*Bạn chưa xác thực tài khoản của mình ! \n*Bạn đã bị khóa tài khoản vì lý do nào đó !", scaffoldKey);
      }
    }
  }
}
