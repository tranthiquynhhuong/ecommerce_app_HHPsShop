import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/components/AppTools.dart';
import 'package:grocery_shop_flutter/repositories/UserRepository.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordPage> {
  UserBloc _userBloc;

  TextEditingController password = new TextEditingController();
  TextEditingController re_new_password = new TextEditingController();
  TextEditingController new_password = new TextEditingController();

  @override
  initState() {
    _userBloc = new UserBloc();
    password.text = "";
    new_password.text = "";
    re_new_password.text = "";
    super.initState();
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  UserRepository userRepository = new UserRepository();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.amber,
        title: Row(
          children: <Widget>[
            Text("Đổi mật khẩu",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            Icon(Icons.phonelink_lock),
          ],
        ),
      ),
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
                    isPassword: true,
                    textHint: "Mật khẩu cũ",
                    textIcon: Icons.lock,
                    controller: password),
                new SizedBox(
                  height: 25.0,
                ),
                appTextField(
                    isPassword: true,
                    textHint: "Mật khẩu mới",
                    textIcon: Icons.lock_outline,
                    controller: new_password),
                new SizedBox(
                  height: 25.0,
                ),
                appTextField(
                    isPassword: true,
                    textHint: "Nhập lại mật khẩu mới",
                    textIcon: Icons.lock_outline,
                    controller: re_new_password),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 50.0, right: 50.0, top: 30.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                appButton(
                  btnTxt: "Lưu thay đổi",
                  onBtnclicked: verifyRegister,
                  btnPadding: 20.0,
                  btnColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  verifyRegister() async {
    if (password.text == "") {
      showSnackbar("Vui lòng nhập mật khẩu !", scaffoldKey);
      return;
    } else if (password.text.length < 6) {
      showSnackbar("Mật khẩu phải từ 6 ký tự trở lên !", scaffoldKey);
      return;
    } else if (new_password.text.length < 6) {
      showSnackbar("Mật khẩu mới phải từ 6 ký tự trở lên !", scaffoldKey);
      return;
    }
    if (new_password.text == "") {
      showSnackbar("Vui lòng nhập mật khẩu mới !", scaffoldKey);
      return;
    } else if (re_new_password.text == "") {
      showSnackbar("Vui lòng nhập lại mật khẩu mới !", scaffoldKey);
      return;
    } else if (new_password.text != re_new_password.text) {
      showSnackbar("Mật khẩu mới nhập lại không đúng !", scaffoldKey);
      return;
    } else if (generateMd5(password.text).toString() !=
        _userBloc.userInfo.password) {
      showSnackbar("Sai mật khẩu!", scaffoldKey);
      return;
    } else if (generateMd5(new_password.text).toString() ==
        _userBloc.userInfo.password) {
      showSnackbar("Mật khẩu mới không được trùng với mật khẩu đang sử dụng!", scaffoldKey);
      return;
    } else if (generateMd5(password.text).toString() ==
            _userBloc.userInfo.password &&
        re_new_password.text != "") {
      displayProgressDialog(context);
      bool response = await _userBloc.updatePasswordUser(
        _userBloc.userInfo.userID,
        generateMd5(new_password.text).toString(),
      );

      if (response == true) {
        closeProgressDialog(context);
        _showDialog();
      } else if (response == false) {
        showSnackbar("Đổi mật khẩu thất bại !", scaffoldKey);
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
            title: Text('THÔNG BÁO'),
            content: Text('Thay đổi mật khẩu thành công!'),
            actions: <Widget>[
              FlatButton(
                color: Colors.green.shade400,
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _userBloc.getUserInfo(_userBloc.userInfo.userID);
                    password.text = "";
                    new_password.text = "";
                    re_new_password.text = "";
                  });
                },
                child: Text('Trở về', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
  }
}
