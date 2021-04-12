import 'package:flutter/material.dart';

class BlurCards extends StatelessWidget {
  Widget content;
  String lable;
  BlurCards({this.content, this.lable});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        (this.lable != null && this.lable.trim() != "")
            ? Container(
                padding: EdgeInsets.only(
                  left: 5,
                ),
                margin: EdgeInsets.only(
                  bottom: 6,
                ),
                child: Text(this.lable),
              )
            : SizedBox(
                height: 10,
              ),
        Card(
          color: Colors.lightBlue,
          elevation: 10,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
            child: this.content,
          ),
        ),
      ],
    );
  }
}
