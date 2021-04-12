import 'package:business_book/screens/page_header.dart';
import 'package:business_book/widgets/dashboard/home_dashboard.dart';
import 'package:business_book/widgets/drawer/app_drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(
        pageTitle: "Home",
      ),
      body: Container(
        child: HomeDashboard(),
      ),
      drawer: AppDrawer(),
    );
  }
}
