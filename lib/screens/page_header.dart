import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PageHeader extends StatefulWidget implements PreferredSizeWidget {
  String pageTitle = "Home";
  PageHeader({Key key, this.pageTitle})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _PageHeaderState createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: AppBar(
        title: Row(children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
          Text(
            widget.pageTitle,
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ]),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
    );
  }
}
