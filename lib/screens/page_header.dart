import 'package:flutter/material.dart';

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
        title: Text(widget.pageTitle),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}