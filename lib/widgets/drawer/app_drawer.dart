import 'package:business_book/utility/singleInstance/configuration.dart';
import 'package:business_book/utility/singleInstance/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  List<dynamic> menu = [
    {
      "name": "Add Folder",
      "icon": FontAwesomeIcons.folderPlus,
      "route": PageNavigation.AddFolderPage,
      "color": Colors.amber
    },
    {
      "name": "Memory",
      "icon": FontAwesomeIcons.brain,
      "route": PageNavigation.MemoryPage,
      "color": Colors.red
    },
    {
      "name": "Voice cmd",
      "icon": FontAwesomeIcons.microphone,
      "route": PageNavigation.VoiceCmdPage,
      "color": Colors.amber
    },
    {
      "name": "Recent",
      "icon": FontAwesomeIcons.book,
      "route": PageNavigation.RecentPage,
      "color": Colors.amber
    },
    {
      "name": "History",
      "icon": FontAwesomeIcons.history,
      "route": PageNavigation.HistoryPage,
      "color": Colors.amber
    },
    {
      "name": "Backup",
      "icon": FontAwesomeIcons.upload,
      "route": PageNavigation.BackupPage,
      "color": Colors.amber
    },
    {
      "name": "Sign Out",
      "icon": FontAwesomeIcons.signOutAlt,
      "route": PageNavigation.LoginPage,
      "color": Colors.amber
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              height: Configuration.pageHeight * .2,
              color: Colors.white38,
              child: Text("Menu Header"),
            ),
            Container(
              child: ListTile(
                title: Text('Your Menu'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white30,
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                  ),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: menu.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        this.menu.elementAt(index)["route"],
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Icon(
                              this.menu.elementAt(index)["icon"],
                              color: Colors.black,
                              size: 16,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Text(
                              this.menu.elementAt(index)["name"],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            flex: 4,
                          ),
                          Expanded(
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black12,
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
