import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/views/ChangePassword.dart';
import 'package:grocery_shop_flutter/views/ChangeUserInfo.dart';
import 'package:grocery_shop_flutter/views/Favorite.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'Receipt.dart';
import 'SignIn.dart';

class AccountManagementPage extends StatefulWidget {
  @override
  _AccountManagementState createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagementPage> {
  UserBloc _userBloc;
  File _imageFile;
  bool uploading = false;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://ecommerce-3b4a8.appspot.com/');

  @override
  initState() {
    _userBloc = UserBloc();
    super.initState();
  }

  Future _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    Navigator.pop(context);
    await uploadImgToStorage(selected);

  }

  Future uploadImgToStorage(image) async {
    setState(() {
      uploading = true;
    });
    try {
      String filename = 'user_profile_image/${Timestamp.now().seconds.toString()}.png';
      StorageReference firebaseStorageRef = _storage.ref().child(filename);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      await uploadTask.onComplete;
      var downUrl = await firebaseStorageRef.getDownloadURL();
      String url = downUrl.toString();
      await _userBloc.updateImageUser(_userBloc.userInfo.userID, url);
    } catch(e) {
      uploading = false;
      print(e);
    }
    setState(() {
      uploading = false;
    });
    //_buildProfileImage(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: new IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.amber,
        title: Row(
          children: <Widget>[
            Text(
              "Quản lý tài khoản",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              width: 50,
              height: 50,
              child: Icon(Icons.account_box),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                _buildCoverImage(),
                SafeArea(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 13,
                        ),
                        _buildProfileImage(_userBloc.userInfo.imgURL),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _userInfoContainer(),
            _myReceiptContainer(),
            _myNotificationContainer(),
            _myFavoriteContainer(),
            Divider(
              color: Colors.grey.shade400,
              thickness: 10,
            ),
            _changeInfoContainer(),
            _changeUserPasswordContainer(),
            Divider(
              color: Colors.grey.shade400,
              thickness: 10,
            ),
            _appInfoContainer(),
            _settingContainer(),
            Divider(
              color: Colors.grey.shade400,
              thickness: 10,
            ),
            _logoutContainer(),
          ],
        ),
      ),
    );
  }

  void _chooseImage() {
    // flutter defined function
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Chọn ảnh tải lên'),
            content: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    color: Colors.amber,
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.photo_camera,
                          color: Colors.black,
                        ),
                        Text(
                          " Chụp ảnh",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    color: Colors.amber,
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.photo_album,
                          color: Colors.black,
                        ),
                        Text(
                          " Chọn ảnh từ thư viện",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green.shade400,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Trở về', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
  }

  Widget _buildCoverImage() {
    return Container(
      height: MediaQuery.of(context).size.height / 4.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://image.freepik.com/free-vector/elegant-black-golden-realistic-christmas-background_1361-1820.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage(String url) {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(
                color: Colors.white,
                width: 5,
              ),
            ),
            child: new CircleAvatar(
              backgroundImage:  _userBloc.userInfo.imgURL != "" ?
              NetworkImage(_userBloc.userInfo.imgURL) : AssetImage('assets/images/avata_default.png'),
            ),
          ),
          uploading ? Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.all(const Radius.circular(100))),
            child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 2,
                )
            ),
          ) : Container(
            height: 200,
            width: 200,
          ),
          Positioned(
            bottom: 0,
            right: 20,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: Center(
                child: InkWell(
                  child: IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () async {
                      await _chooseImage();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _myReceiptContainer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade300,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 13.0,
              color: Colors.grey.withOpacity(.3),
              offset: Offset(6.0, 7.0),
            ),
          ],
          gradient: new LinearGradient(colors: [
            Colors.white.withOpacity(0.3),
            Colors.amber,
            Colors.orange
          ], begin: Alignment.centerRight, end: new Alignment(-1.0, -1.0)),
        ),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => new ReceiptPage()));
          },
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  "Đơn hàng của tôi",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.receipt,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Text(
              ">",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _changeInfoContainer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade300,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 13.0,
              color: Colors.grey.withOpacity(.3),
              offset: Offset(6.0, 7.0),
            ),
          ],
          gradient: new LinearGradient(colors: [
            Colors.white.withOpacity(0.3),
            Colors.amber,
            Colors.orange
          ], begin: Alignment.centerRight, end: new Alignment(-1.0, -1.0)),
        ),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new ChangeUserInfo()));
          },
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  "Đổi thông tin tài khoản",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Text(
              ">",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _changeUserPasswordContainer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade300,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 13.0,
              color: Colors.grey.withOpacity(.3),
              offset: Offset(6.0, 7.0),
            ),
          ],
          gradient: new LinearGradient(colors: [
            Colors.white.withOpacity(0.3),
            Colors.amber,
            Colors.orange
          ], begin: Alignment.centerRight, end: new Alignment(-1.0, -1.0)),
        ),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new ChangePasswordPage()));
          },
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  "Đổi mật khẩu",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Text(
              ">",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _myNotificationContainer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade300,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 13.0,
              color: Colors.grey.withOpacity(.5),
              offset: Offset(6.0, 7.0),
            ),
          ],
          gradient: new LinearGradient(colors: [
            Colors.white.withOpacity(0.3),
            Colors.amber,
            Colors.orange
          ], begin: Alignment.centerRight, end: new Alignment(-1.0, -1.0)),
        ),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: InkWell(
          onTap: () {},
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  "Thông báo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.notifications_active,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Text(
              ">",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
  Widget _myFavoriteContainer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade300,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 13.0,
              color: Colors.grey.withOpacity(.5),
              offset: Offset(6.0, 7.0),
            ),
          ],
          gradient: new LinearGradient(colors: [
            Colors.white.withOpacity(0.3),
            Colors.amber,
            Colors.orange
          ], begin: Alignment.centerRight, end: new Alignment(-1.0, -1.0)),
        ),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new FavoritePage()));
          },
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  "Yêu thích",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Text(
              ">",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _settingContainer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade300,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 13.0,
              color: Colors.grey.withOpacity(.5),
              offset: Offset(6.0, 7.0),
            ),
          ],
          gradient: new LinearGradient(colors: [
            Colors.white.withOpacity(0.3),
            Colors.lightGreenAccent,
            Colors.green
          ], begin: Alignment.centerRight, end: new Alignment(-1.0, -1.0)),
        ),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: InkWell(
          onTap: () {},
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  "Cài đặt",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Text(
              ">",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appInfoContainer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade300,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 13.0,
              color: Colors.grey.withOpacity(.5),
              offset: Offset(6.0, 7.0),
            ),
          ],
          gradient: new LinearGradient(colors: [
            Colors.white.withOpacity(0.3),
            Colors.lightBlueAccent,
            Colors.blue
          ], begin: Alignment.centerRight, end: new Alignment(-1.0, -1.0)),
        ),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: InkWell(
          onTap: () {},
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  "Thông tin ứng dụng",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Text(
              ">",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutContainer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade500,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 13.0,
              color: Colors.grey.withOpacity(.5),
              offset: Offset(6.0, 7.0),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: InkWell(
          onTap: () async {
            bool _isLogout = await _userBloc.logout();
            if (_isLogout) {
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(builder: (context) => new SignIn()),
                  (Route<dynamic> route) => false);
            } else {
              print('Đăng xuất thất bại');
            }
          },
          child: ListTile(
            title: Center(
              child: Text(
                "Đăng xuất",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userInfoContainer() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              _userBloc.userInfo.fullname,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Center(
            child: Text(
              _userBloc.userInfo.email,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
          Center(
            child: Text(
              "Tham gia từ: " +
                  getDate(DateTime.parse(_userBloc.userInfo.signupdate))
                      .toString(),
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  getDate(DateTime dateTimeInput) {
    String processedDate;
    processedDate = DateFormat('dd/MM/yyyy').format(dateTimeInput);
    return processedDate;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Uploader {}
