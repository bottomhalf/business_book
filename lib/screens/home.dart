import 'package:business_book/dao/menu_dao.dart';
import 'package:business_book/manage_db/menu.dart';
import 'package:business_book/screens/page_header.dart';
import 'package:business_book/utility/singleInstance/configuration.dart';
import 'package:business_book/widgets/dashboard/home_dashboard.dart';
import 'package:business_book/widgets/drawer/app_drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  void initPageDetail() {
    Configuration.pageHeight = MediaQuery.of(context).size.height;
    Configuration.pageWidget = MediaQuery.of(context).size.width;
    print(Configuration.pageHeight);
  }

  @override
  void initState() {
    this.menu = MenuAction();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initPageDetail();
      this.reloadData();
    });
    super.initState();
  }

  MenuAction menu;
  List<Menu> menuItems = [];

  Future reloadData() async {
    menu = MenuAction();
    var items = menu.getFullMenu();
    items.then((menuDetail) {
      print("Result: ${menuDetail}");
      setState(() {
        this.menuItems = menuDetail;
        this.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(child: Scaffold(
      appBar: PageHeader(pageTitle: "Home",),
      body: this.isLoading ? Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
      ) : Container(
        child: HomeDashboard(
          menuItems: this.menuItems,
        ),
      ),
      drawer: AppDrawer(),
    ), onRefresh: reloadData);
  }
}
