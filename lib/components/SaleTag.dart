import 'package:flutter/material.dart';

class SaleTag extends StatelessWidget {
  final String discout;
  SaleTag({this.discout});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80),
      child: new Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.red,Colors.orange],
                begin: Alignment.centerRight,
                end: new Alignment(-1.0, -1.0)),

            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: 50,
        height: 25,
        child: Center(
          child: Text(
            "-" + discout + "%",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
