import 'dart:convert';

import 'package:business_book/dao/menu_dao.dart';
import 'package:business_book/manage_db/menu.dart';
import 'package:business_book/utility/singleInstance/configuration.dart';
import 'package:business_book/utility/singleInstance/page_navigation.dart';
import 'package:business_book/widgets/dashboard/appinfo_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  MenuAction action;
  bool isLoading = true;
  List<Menu> menuItems = [];

  @override
  void initState() {
    print("Dashboard home called");
    action = MenuAction();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reloadData();
    });
    super.initState();
  }

  Future reloadData() async {
    action = MenuAction();
    var items = action.getFullMenu();
    items.then((menuDetail) {
      setState(() {
        this.menuItems = menuDetail;
        this.isLoading = false;
      });
    });
  }

  String getMessage(String msg) {
    if (msg != null && msg != "")
      return msg;
    else
      return "Please edit to add some comments for this folder. Comment will describe detail about the folder like "
          "why this folder used, file content type for this folder etc.";
  }

  Widget getDashboardItems() {
    if (menuItems.length > 0) {
      Menu item;
      return ListView.builder(
          shrinkWrap: true,
          itemCount: menuItems.length + 1,
          itemBuilder: (_, i) {
            if (i == 0) {
              return InfoDashboardCard(
                reloadPage: reloadData,
              );
            } else {
              item = menuItems.elementAt(i - 1);
              return Container(
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.solidFolder,
                          color: Colors.amber,
                        ),
                        title: Text(item.catagoryName),
                        trailing: InkWell(
                          onTap: () {
                            _openFolder(item.uId);
                          },
                          child: Icon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 14, left: 14, right: 10),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            Text(
                              getMessage(item.catagoryDescription),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              color: Colors.deepPurple,
                              iconSize: 14,
                              icon: Icon(
                                FontAwesomeIcons.pencilAlt,
                              ),
                              onPressed: () {
                                _editCurrent(i - 1);
                              },
                            ),
                            IconButton(
                              color: Colors.red,
                              iconSize: 14,
                              icon: Icon(
                                FontAwesomeIcons.trash,
                              ),
                              onPressed: () {
                                _deleteCurrent(i - 1);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          });
    } else {
      return emptyDesktop();
    }
  }

  Future<void> _openFolder(int index) {
    if (index != 0) {
      Navigator.pushNamed(context, PageNavigation.FolderDetailPage,
          arguments: index);
    } else {
      Fluttertoast.showToast(msg: "Unable to find. Contact admin.");
    }
  }

  Future<void> _addFolder() async {}

  Future<void> _deleteCurrent(int index) async {
    if (index >= 0) {
      await this.action.delete(menuItems.elementAt(index)).then((result) {
        if (result != null) {
          print('Deleted result: $result');
        }
        this.reloadData();
        Fluttertoast.showToast(msg: 'Folder deleted successfully');
      });
    }
  }

  Future<void> _editCurrent(int index) async {
    if (index >= 0) {
      var catagoryName = menuItems.elementAt(index).catagoryName;
      print('catagoryName: $catagoryName');
      if (catagoryName != null) {
        var result = this.action.find(catagoryName);
        result.then((Menu item) {
          if (item != null &&
              item.catagoryName != null &&
              item.catagoryName != "") {
            Navigator.pushNamed(context, PageNavigation.AddFolderPage,
                arguments: menuItems.elementAt(index).catagoryName);
          } else {
            Fluttertoast.showToast(
                msg: "Invalid record fetched. Please contact to admin.");
          }
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Unable to find. Contact admin.");
    }
  }

  Widget emptyDesktop() {
    return ListView(
      shrinkWrap: true,
      children: [
        InfoDashboardCard(
          reloadPage: reloadData,
        ),
        Row(
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Configuration.pageWidget * .08,
                  vertical: Configuration.pageWidget * .2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.dotCircle,
                            color: Colors.black45,
                            size: 12,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 1, left: 10),
                            child: Text(
                              'There is no item found.',
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.dotCircle,
                            color: Colors.black45,
                            size: 12,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 1, left: 10),
                            child: Text(
                              'Please use the below button to add new folder.',
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.dotCircle,
                          color: Colors.black45,
                          size: 12,
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(top: 1, left: 10),
                            child: Text(
                              'You can add images, pdf, doc, excel and other file after creating the folder. '
                              'For more information please click the below link.',
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 8,
                        top: 20,
                      ),
                      child: Text(
                        'Files and folder detail',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: this.reloadData,
      child: isLoading
          ? Container(
              margin: EdgeInsets.only(top: 50),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(Configuration.pageWidget * .05),
                  child: getDashboardItems(),
                ),
                Positioned(
                  bottom: Configuration.pageHeight * .05,
                  left: 0,
                  right: 0,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, PageNavigation.AddFolderPage);
                    },
                    child: Icon(FontAwesomeIcons.plus),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
    );
  }
}
