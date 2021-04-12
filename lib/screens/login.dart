import 'package:business_book/utility/singleInstance/configuration.dart';
import 'package:business_book/utility/singleInstance/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _userId = TextEditingController();
  final _password = TextEditingController();
  final _form = GlobalKey<FormState>();

  void initPageDetail() {
    Configuration.pageHeight = MediaQuery.of(context).size.height;
    Configuration.pageWidget = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    _userId.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initPageDetail();
    });
    super.initState();
  }

  void _login() {
    final state = this._form.currentState.validate();
    if (state) {
      if (_userId.text == 'istiyak' && _password.text == '12345') {
        Fluttertoast.showToast(msg: "Login success.");
        Navigator.pushReplacementNamed(context, PageNavigation.Home);
      } else {
        Fluttertoast.showToast(msg: "Incorrect username or password");
      }
    } else {
      Fluttertoast.showToast(msg: "Invalid username or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/screen1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.only(
          top: 0,
          bottom: 0,
          left: 25,
          right: 25,
        ),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'Cloud Book',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 50,
                  ),
                ),
                margin: EdgeInsets.only(bottom: 5),
              ),
              Container(
                child: Icon(
                  FontAwesomeIcons.cloudUploadAlt,
                  color: Colors.redAccent,
                  size: 40,
                ),
                margin: EdgeInsets.only(bottom: 40),
              ),
              Container(
                margin: EdgeInsets.only(bottom: Configuration.pageWidget * .04),
                child: TextFormField(
                  //controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    border: OutlineInputBorder(),
                    labelText: 'User Id/Email Id',
                    hintText: 'User Id/Email Id',
                  ),
                  validator: (value) {
                    if (value == null || value.trim() == "")
                      return "Folder name is mandatory";
                    return null;
                  },
                  controller: _userId,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: Configuration.pageWidget * .04),
                child: TextFormField(
                  //controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Your Password',
                  ),
                  validator: (value) {
                    if (value == null || value.trim() == "")
                      return "Folder name is mandatory";
                    return null;
                  },
                  controller: _password,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: Configuration.pageWidget * .04),
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                    _login();
                  },
                  child: Text("Login"),
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
