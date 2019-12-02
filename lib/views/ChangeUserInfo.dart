import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/components/AppTools.dart';

class ChangeUserInfo extends StatefulWidget {
  @override
  _ChangeUserInfoState createState() => _ChangeUserInfoState();
}

class _ChangeUserInfoState extends State<ChangeUserInfo> {
  UserBloc _userBloc;

  TextEditingController fullname = new TextEditingController();
  TextEditingController location = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  String gender;
  String groupValue;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;

  @override
  void initState() {
    _userBloc = new UserBloc();
    fullname.text = _userBloc.userInfo.fullname;
    location.text = _userBloc.userInfo.location;
    email.text = _userBloc.userInfo.email;
    phone.text = _userBloc.userInfo.phone;
    groupValue = _userBloc.userInfo.gender;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.amber,
        title: Row(
          children: <Widget>[
            Text("Thông tin cá nhân",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            Icon(Icons.person),
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
    } else if (location.text == "") {
      showSnackbar("Vui lòng nhập địa chỉ !", scaffoldKey);
      return;
    }

    if (phone.text == "") {
      showSnackbar("Vui lòng nhập điện thoại di động !", scaffoldKey);
      return;
    } else {
      displayProgressDialog(context);
      bool response = await _userBloc.updateInfoUser(
        _userBloc.userInfo.userID,
        fullname.text,
        email.text,
        groupValue,
        location.text,
        phone.text,
      );

      if (response == true) {
        closeProgressDialog(context);
        _showDialog();
      } else if (response == false) {
        showSnackbar("Cập nhật thông tin thất bại !", scaffoldKey);
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
            content: Text('Thay đổi thông tin thành công'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _userBloc.getUserInfo(_userBloc.userInfo.userID);
                  });
                },
                child: Text('Đóng'),
              )
            ],
          );
        });
  }
}
