import 'package:business_book/dao/menu_dao.dart';
import 'package:business_book/manage_db/menu.dart';
import 'package:business_book/screens/page_header.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IFolders extends StatefulWidget {
  @override
  _IFoldersState createState() => _IFoldersState();
}

class _IFoldersState extends State<IFolders> {
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

  Widget getDashboardItems() {
    return ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (_, index) {
          return Container(
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.solidFolder,
                      color: Colors.amber,
                    ),
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
                    padding: EdgeInsets.only(top: 14, left: 14, right: 10),
                    child: Wrap(
                      children: [
                        Text('This folder container information '
                            'about computer, laptop RAM, Pendrive and other stuffs.')
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
              ),
            ),
          );
        });
  }

  Future<void> _openFolder(int index) {}

  Future<void> _addFolder() async {}

  Future<void> _deleteCurrent(int index) async {
    if (action != null) {
      await this.action.delete(menuItems.elementAt(index)).then((result) {
        if (result != null) {
          print('Deleted result: $result');
        }
        this.reloadData();
        Fluttertoast.showToast(msg: 'Folder deleted successfully');
      });
    }
  }

  Future<void> _editCurrent(int index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(
        pageTitle: "Folders",
      ),
      body: RefreshIndicator(
        onRefresh: this.reloadData,
        child: Container(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : getDashboardItems(),
        ),
      ),
    );
  }
}
