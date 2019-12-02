import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';

import 'ProgressDialog.dart';

Widget appTextField(
    {IconData textIcon,
    String textHint,
    bool isPassword,
    TextInputType textType,
    TextEditingController controller}) {
  textHint == null ? textHint = "" : textHint;

  return Padding(
    padding: EdgeInsets.only(left: 18.0, right: 18.0),
    child: new Container(
      decoration: new BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: new BorderRadius.all(new Radius.circular(15.0))),
      child: new TextField(
        controller: controller,
        obscureText: isPassword == null ? false : isPassword,
        keyboardType: textType == null ? TextInputType.text : textType,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: textHint == null ? "" : textHint,
          prefixIcon: textIcon == null ? new Container() : new Icon(textIcon),
        ),
      ),
    ),
  );
}

Widget appButton(
    {String btnTxt,
    double btnPadding,
    Color btnColor,
    VoidCallback onBtnclicked}) {
  btnTxt == null ? btnTxt = "App Button" : btnTxt;
  btnTxt == null ? btnPadding = 0.0 : btnPadding;
  btnColor == null ? btnColor = null : btnColor;

  return Padding(
    padding: new EdgeInsets.all(btnPadding),
    child: new RaisedButton(
      color: Colors.white,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(15.0))),
      onPressed: onBtnclicked,
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: new Text(
            btnTxt,
            style: TextStyle(color: btnColor, fontSize: 18.0),
          ),
        ),
      ),
    ),
  );
}

showSnackbar(String message, final scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.black,
      content: new Text(
        message,
        style: new TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      )));
}

displayProgressDialog(BuildContext context) {
  Navigator.of(context).push(new PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return new ProgressDialog();
      }));
}

closeProgressDialog(BuildContext context) {
  Navigator.of(context).pop();
}

generateMd5(String data) {
  var bytes = utf8.encode(data); // data being hashed
  var digest = crypto.md5.convert(bytes);
  return digest;
}

