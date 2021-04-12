import 'package:business_book/screens/add_folder.dart';
import 'package:business_book/screens/backup.dart';
import 'package:business_book/screens/folder_detail.dart';
import 'package:business_book/screens/history.dart';
import 'package:business_book/screens/home.dart';
import 'package:business_book/screens/login.dart';
import 'package:business_book/screens/memory.dart';
import 'package:business_book/screens/recent.dart';
import 'package:business_book/screens/voice_command.dart';
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
        PageNavigation.Home: (_) => Home(),
        PageNavigation.AddFolderPage: (_) => AddFolder(),
        PageNavigation.LoginPage: (_) => Login(),
        PageNavigation.MemoryPage: (_) => Memory(),
        PageNavigation.VoiceCmdPage: (_) => VoiceCommand(),
        PageNavigation.RecentPage: (_) => Recent(),
        PageNavigation.HistoryPage: (_) => History(),
        PageNavigation.BackupPage: (_) => BackUp(),
        PageNavigation.FolderDetailPage: (_) => FolderDetail()
      },
      onUnknownRoute: (setting) {
        return MaterialPageRoute(builder: (_) => Login());
      },
    );
  }
}
