import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/components/AppTools.dart';
import 'package:grocery_shop_flutter/repositories/UserRepository.dart';
import 'package:grocery_shop_flutter/views/SignIn.dart';
import 'package:crypto/crypto.dart' as crypto;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fullname = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController re_password = new TextEditingController();
  TextEditingController location = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  String gender;
  String groupValue = "Nam";

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  UserRepository userRepository = new UserRepository();

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
                  height: 70.0,
                ),
                appTextField(
                  isPassword: false,
                  textHint: "Họ và tên",
                  textIcon: Icons.person,
                  controller: fullname,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ListTile(
                        title: Text("Nam",
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Colors.white)),
                        trailing: Radio(
                          activeColor: Colors.white,
                          value: "Nam",
                          groupValue: groupValue,
                          onChanged: (e) => valueChange(e),
                        ),
                      )),
                      Expanded(
                          child: ListTile(
                        title: Text("Nữ",
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Colors.white)),
                        trailing: Radio(
                          activeColor: Colors.white,
                          value: "Nữ",
                          groupValue: groupValue,
                          onChanged: (e) => valueChange(e),
                        ),
                      )),
                    ],
                  ),
                ),
                appTextField(
                  isPassword: false,
                  textHint: "Email",
                  textIcon: Icons.email,
                  controller: email,
                  textType: TextInputType.emailAddress,
                ),
                new SizedBox(
                  height: 25.0,
                ),
                appTextField(
                    isPassword: true,
                    textHint: "Mật khẩu",
                    textIcon: Icons.lock,
                    controller: password),
                new SizedBox(
                  height: 25.0,
                ),
                appTextField(
                    isPassword: true,
                    textHint: "Nhập lại mật khẩu",
                    textIcon: Icons.lock,
                    controller: re_password),
                new SizedBox(
                  height: 25.0,
                ),
                appTextField(
                  isPassword: false,
                  textHint: "Địa chỉ",
                  textIcon: Icons.location_on,
                  controller: location,
                ),
                new SizedBox(
                  height: 25.0,
                ),
                appTextField(
                    isPassword: false,
                    textHint: "Điện thoại",
                    textIcon: Icons.phone,
                    controller: phone,
                    textType: TextInputType.number),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 50.0, right: 50.0, top: 30.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                appButton(
                  btnTxt: "Đăng ký",
                  onBtnclicked: verifyRegister,
                  btnPadding: 20.0,
                  btnColor: Theme.of(context).primaryColor,
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new SignIn()));
                  },
                  child: new Text(
                    "Đăng nhập",
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  valueChange(e) {
    setState(() {
      if (e == "Nam") {
        groupValue = e;
        gender = e;
      } else if (e == "Nữ") {
        groupValue = e;
        gender = e;
      }
    });
  }

  verifyRegister() async {
    if (fullname.text == "") {
      showSnackbar("Vui lòng nhập họ và tên !", scaffoldKey);
      return;
    } else if (email.text == "") {
      showSnackbar("Vui lòng nhập Email !", scaffoldKey);
      return;
    } else if (!email.text.contains("@")) {
      showSnackbar("Email không hợp lệ !", scaffoldKey);
      return;
    }

    bool check = await userRepository.checkEmailExist(email.text);
    if (check == true) {
      showSnackbar("Email đã tồn tại, vui lòng chọn Email khác !", scaffoldKey);
      return;
    } else if (password.text == "") {
      showSnackbar("Vui lòng nhập mật khẩu !", scaffoldKey);
      return;
    } else if (password.text.length < 6) {
      showSnackbar("Mật khẩu phải từ 6 ký tự trở lên !", scaffoldKey);
      return;
    } else if (re_password.text == "") {
      showSnackbar("Vui lòng nhập lại mật khẩu !", scaffoldKey);
      return;
    } else if (location.text == "") {
      showSnackbar("Vui lòng nhập địa chỉ !", scaffoldKey);
      return;
    }

    if (phone.text == "") {
      showSnackbar("Vui lòng nhập điện thoại di động !", scaffoldKey);
      return;
    } else if (password.text != re_password.text) {
      showSnackbar("Mật khẩu nhập lại không đúng !", scaffoldKey);
      return;
    } else {
      displayProgressDialog(context);
      bool response = await userRepository.createdUserAccount(
        fullName: fullname.text,
        password: generateMd5(password.text).toString(),
        email: email.text,
        groupValue: groupValue.toString(),
        location: location.text,
        phone: phone.text,
      );

      if (response == true) {
        closeProgressDialog(context);
        _showDialog();
      } else if (response == false) {
        showSnackbar("Đăng ký thất bại !", scaffoldKey);
        closeProgressDialog(context);
      }
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Đăng ký tài khoản thành công'),
            content: Text("*Vui lòng XÁC THỰC email để có thể ĐĂNG NHẬP",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
            actions: <Widget>[
              FlatButton(
                color: Colors.green.shade400,
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new SignIn()));
                },
                child: Text('Đã hiểu',style: TextStyle(color: Colors.white),
              )
              )],
          );
        });
  }
}
