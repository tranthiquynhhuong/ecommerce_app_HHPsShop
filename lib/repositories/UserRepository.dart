import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_shop_flutter/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  Firestore firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<User>> getAllUser() async {
    List<User> users = [];
    var result = await firestore.collection('User').getDocuments();
    for (var user in result.documents) {
      users.add(User(
        user.data['userID'],
        user.data['accFullName'],
        user.data['email'],
        user.data['password'],
        user.data['gender'],
        user.data['signupdate'],
        user.data['location'],
        user.data['phone'],
        user.data['imgURL'],
      ));
    }
    return users;
  }

  // ignore: missing_return
  Future<User> getUserInfo(String userid) async {
    var result = await Firestore.instance
        .collection('User')
        .where('userID', isEqualTo: userid)
        .getDocuments();
    for (var user in result.documents) {
      return User(
        user.data['userID'],
        user.data['accFullName'],
        user.data['email'],
        user.data['password'],
        user.data['gender'],
        user.data['signupdate'],
        user.data['location'],
        user.data['phone'],
        user.data['imgURL'],
      );
    }
  }

  Future<User> loginUser(String email, String password) async {
    FirebaseUser user;
    User userInfo;
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;

      if (user != null && user.isEmailVerified) {
        userInfo = await getUserInfo(user.uid);
      }
      return userInfo;
    } catch (e) {
      return e.details;
    }
  }

  Future<bool> logout() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User> checkAuth() async {
    var _user = await FirebaseAuth.instance.currentUser();
    if (_user != null) {
      User userInfo = await getUserInfo(_user.uid);
      return userInfo;
    }
    return null;
  }

  Future<bool> createdUserAccount(
      {String fullName,
      String groupValue,
      String password,
      String email,
      String location,
      String phone}) async {
    FirebaseUser user;

    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;

      try {
        await user.sendEmailVerification();
        if (user != null) {
          await firestore.collection('User').document(user.uid).setData({
            'userID': user.uid,
            'accFullName': fullName,
            'email': email,
            'gender': groupValue,
            'password': password,
            'phone': phone,
            'location': location,
            'signupdate': DateTime.now().toString(),
            'imgURL':"",
          });
        }
      } catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
      }
    } catch (e) {
      return notComplete();
    }
    return complete();
  }

  Future<bool> updateInfoUser(
      {String userID,
      String fullname,
      String gender,
      String location,
      String phone}) async {
    try {
      var result = await Firestore.instance
          .collection('User')
          .document(userID)
          .updateData({
        'accFullName': fullname,
        'gender': gender,
        'location': location,
        'phone': phone,
      });
    } catch (e) {
      return notComplete();
    }
    return complete();
  }

  Future<bool> updateImageURL(
      {String imgURL,String userID}) async {
    try {
      var result = await Firestore.instance
          .collection('User')
          .document(userID)
          .updateData({
        'imgURL': imgURL,
      });
    } catch (e) {
      return notComplete();
    }
    return complete();
  }

  Future<bool> updatePasswordUser({
    String userID,
    String password,
  }) async {
    try {
      var result = await Firestore.instance
          .collection('User')
          .document(userID)
          .updateData({
        'password': password,
      });

      FirebaseUser user = await auth.currentUser();
      await user.updatePassword(password).then((_){
        print("Succesfull changed password");
      }).catchError((error){
        print("Password can't be changed" + error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });

    } catch (e) {
      return notComplete();
    }
    return complete();
  }

  Future<bool> complete() async {
    return true;
  }

  Future<bool> notComplete() async {
    return false;
  }

  Future<String> successfulMSG() async {
    return "successful";
  }

  Future<String> errorMSG(String e) async {
    return e;
  }

  @override
  Future<bool> logOutUser() async {
    await auth.signOut();
    return complete();
  }

  Future<bool> checkEmailExist(String email) async {
    var result = await Firestore.instance
        .collection('User')
        .where('email', isEqualTo: email)
        .getDocuments();
    if (result.documents.length == 1) {
      return true;
    } else
      return false;
  }
}
