import 'package:business_book/utility/singleInstance/configuration.dart';
import 'package:business_book/utility/singleInstance/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
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
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Card(child: ListTile(title: Text('Your Menu'))),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, PageNavigation.AddFolderPage);
                  },
                  child: Card(
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.folderPlus, color: Colors.amber,),
                      title: Text('Add Folder'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
