import 'package:business_book/dao/menu_dao.dart';
import 'package:business_book/manage_db/local_db.dart';
import 'package:business_book/manage_db/menu.dart';
import 'package:business_book/screens/page_header.dart';
import 'package:business_book/utility/singleInstance/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sembast/timestamp.dart';

class AddFolder extends StatefulWidget {
  @override
  _AddFolderState createState() => _AddFolderState();
}

class _AddFolderState extends State<AddFolder> {
  final _form = GlobalKey<FormState>();
  final _folderName = TextEditingController();
  final _folderDescription = TextEditingController();
  final MenuAction action = MenuAction();

  Future _createFolder() async {
    _form.currentState.save();
    var state = _form.currentState.validate();
    if(state) {
        await action.insert(Menu(
          parentName: _folderName.text,
          createdOn: Timestamp.now(),
          catagoryName: _folderDescription.text
        )).then((result) {
          if(result != null && result > 0) {
            _folderName.text = '';
            _folderDescription.text = '';
            Fluttertoast.showToast(msg: "Folder created successfully");
          } else {
            Fluttertoast.showToast(msg: "Fail to add folder.");
          }
        });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _folderName.dispose();
    _folderDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(pageTitle: "Add Folder",),
      body: Container(
        padding: EdgeInsets.all(Configuration.pageWidget * .08),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: Configuration.pageWidget * .04),
                child: TextFormField(
                  //controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    hintText: 'Enter Your Name',
                  ),
                  validator: (value) {
                    if(value == null || value.trim() == "")
                      return "Folder name is mandatory";
                    return null;
                  },
                  controller: _folderName,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: Configuration.pageWidget * .04),
                child: TextFormField(
                  //controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    hintText: 'Enter Description',
                  ),
                  maxLines: 6,
                  controller: _folderDescription,
                  validator: (value) {
                    if(value == null || value.trim() == "")
                      return "Folder description is mandatory";
                    return null;
                  }
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: Configuration.pageWidget * .04),
                child: RaisedButton(
                  onPressed: () {
                    _createFolder();
                  },
                  child: Text("Add"),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
