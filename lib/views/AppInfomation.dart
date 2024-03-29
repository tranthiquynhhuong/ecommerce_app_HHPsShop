import 'package:flutter/material.dart';

class AppInfomation extends StatefulWidget {
  @override
  _AppInfomationState createState() => _AppInfomationState();
}

class _AppInfomationState extends State<AppInfomation> {
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
              "Thông tin ứng dụng",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              width: 50,
              height: 50,
              child: Icon(Icons.perm_device_information),
            ),
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  "BỘ GIÁO DỤC VÀ ĐÀO TẠO",
                  style: TextStyle(color: Colors.black,),
                ),
                Text(
                  "TRƯỜNG ĐẠI HỌC HOA SEN",
                  style: TextStyle(color: Colors.black,),
                ),
                Text(
                  "KHOA CÔNG NGHỆ THÔNG TIN",
                  style: TextStyle(color: Colors.black,),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Image.asset('assets/images/logo_hoasen.jpg'),
                  ),
                ),
                Text(
                  "ĐỒ ÁN CHUYÊN NGÀNH A",
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.grey),
                ),
                Text(
                  "Building M-commerce system",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  "with Google Flutter and Firebase",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Text(
                    "Giảng viên hướng dẫn: Trang Hồng Sơn",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Lớp: PM151 - QL161",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Thời gian thực hiện: 9/9/2019 -> 14/12/2019",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "STT nhóm: 14",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "NHÓM SINH VIÊN THỰC HIỆN",
                    style: TextStyle(fontSize: 15, color: Colors.black,decoration: TextDecoration.underline),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Trần Thị Quỳnh Hương - PM151 - 2153003",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Nguyễn Gia Minh - QL161 - 2162419",
                    style: TextStyle(fontSize: 15, color: Colors.black,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "THÁNG 12 / NĂM 2019",
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
