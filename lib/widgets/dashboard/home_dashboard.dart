import 'package:business_book/dao/menu_dao.dart';
import 'package:business_book/manage_db/menu.dart';
import 'package:business_book/utility/singleInstance/configuration.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sembast/timestamp.dart';

class HomeDashboard extends StatefulWidget {
  List<Menu> menuItems;
  HomeDashboard({this.menuItems});

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  MenuAction action;
  List<Menu> menuItems = [];

  @override
  void initState() {
    action = MenuAction();
    setState(() {
      this.menuItems = widget.menuItems;
    });
  }

  Future reloadData() async {
    var items = action.getFullMenu();
    items.then((menuDetail) {
      setState(() {
        this.menuItems = menuDetail;
      });
    });
  }

  Future<void> _openFolder(int index) {

  }

  Future<void> _addFolder() async {
    await action.insert(Menu(
      catagoryName: 'Computer',
      createdOn: Timestamp.now(),
      parentName: null
    )).then((value) {
      Fluttertoast.showToast(msg: "Folder created successfully");
      this.reloadData();
    });
  }

  Future<void> _deleteCurrent(int index) async {
    if(action != null) {
      await this.action.delete(menuItems.elementAt(index)).then((result) {
        if(result != null) {
          print('Deleted result: $result');
        }
        Fluttertoast.showToast(msg: 'Folder deleted successfully');
      });
    }
  }

  Future<void> _editCurrent(int index) {}

  Widget getDashboardItems() {
    return ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (_, index) {
          return Container(
            child: Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(FontAwesomeIcons.solidFolder, color: Colors.amber,),
                      title: Text(menuItems.elementAt(index).catagoryName),
                      trailing: InkWell(
                        onTap: () {
                          _openFolder(index);
                        },
                        child: Icon(
                          FontAwesomeIcons.angleRight,
                          color: Colors.black12,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 14,
                        left: 14,
                        right: 10
                      ),
                      child: Wrap(
                        children: [
                          Text('This folder container information '
                              'about computer, laptop RAM, Pendrive and other stuffs.')
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          right: 10
                      ),
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
                                  _editCurrent(index);
                                },
                              ),
                              IconButton(
                                color: Colors.red,
                                iconSize: 14,
                                icon: Icon(
                                  FontAwesomeIcons.trash,
                                ),
                                onPressed: () {
                                  _deleteCurrent(index);
                                },
                              )
                            ],
                          ),
                    )
                  ],
                )
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Configuration.pageWidget * .04),
      child: this.menuItems.length == 0 ? Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(text: 'Welcome to the BottomhHalf.'),
                      TextSpan(text: 'Please click Add folder button to start adding your folder.'),
                      TextSpan(text: 'After adding main folder you can also add sub-folders and file inside it.'),
                    ]
                  ),
              ),
              RaisedButton(
                onPressed: () {
                  _addFolder();
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child:
                    const Text('Add folder',
                        style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
          :
      getDashboardItems(),
    );
  }
}
