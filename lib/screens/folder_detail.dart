import 'package:business_book/dao/menu_dao.dart';
import 'package:business_book/screens/page_header.dart';
import 'package:flutter/material.dart';

class FolderDetail extends StatefulWidget {
  @override
  _FolderDetailState createState() => _FolderDetailState();
}

class _FolderDetailState extends State<FolderDetail> {
  bool isLoading = true;
  final MenuAction action = MenuAction();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Uid = ModalRoute.of(context).settings.arguments as int;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Future _loadData() {

  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: Scaffold(
        appBar: PageHeader(
          pageTitle: 'Folder content',
        ),
        body: Center(
          child: Container(
            child: Text('Folder content'),
          ),
        ),
      ),
    );
  }
}
