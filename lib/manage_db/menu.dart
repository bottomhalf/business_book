import 'package:sembast/timestamp.dart';

class Menu {
  String catagoryName;
  String parentName;
  Timestamp createdOn;

  Menu({
    this.catagoryName,
    this.parentName,
    this.createdOn
  });

  factory Menu.fromJson(Map<String, dynamic> record) => Menu(
    catagoryName: record["catagoryName"],
    createdOn: Timestamp.now(),
    parentName: record["parentName"]
  );

  Map<String, dynamic> toJson() => {
    "catagoryName": this.catagoryName,
    "parentName": this.parentName,
    "createdOn": this.createdOn
  };

  @override
  String toString() {
    return 'Menu{catagoryName: $catagoryName, parentName: $parentName, createdOn: $createdOn}';
  }
}