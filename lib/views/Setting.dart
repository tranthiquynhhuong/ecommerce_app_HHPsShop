import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/ThemeBloc.dart';

class Setting extends StatefulWidget {

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final _themeBloc=ThemeBloc();

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
              "Cài đặt",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              width: 50,
              height: 50,
              child: Icon(Icons.settings_applications),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        initialData: _themeBloc.dartThemeEnabled,
        stream: _themeBloc.observableTheme,
        builder: (context, snapshot) {
          return Container(
            child: ListTile(
              title: Text("Chủ đề ban đêm",style: TextStyle(color: Colors.black),),
              trailing: Container(
                width: 70,
                child: Switch(
                  value: snapshot.data,
                  onChanged: (value){
                    _themeBloc.changeTheme();
                  },
                ),
              ),
            ),
          );
        }
      ),
    );
  }


}
