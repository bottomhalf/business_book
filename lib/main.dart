import 'package:business_book/screens/add_folder.dart';
import 'package:business_book/screens/home.dart';
import 'package:business_book/utility/singleInstance/page_navigation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        PageNavigation.Home : (_) => Home(),
        PageNavigation.AddFolderPage: (_) => AddFolder()
      },
      onUnknownRoute: (setting) {
        return MaterialPageRoute(builder: (_) => Home());
      },
    );
  }
}