import 'package:sembast/timestamp.dart';

class Menu {
  int uId;
  String catagoryName;
  String catagoryDescription;
  String parentName;
  Timestamp createdOn;

  Menu(
      {this.uId,
      this.catagoryName,
      this.catagoryDescription,
      this.parentName,
      this.createdOn});

  factory Menu.fromJson(Map<String, dynamic> record, int UniqueId) => Menu(
      catagoryName: record["catagoryName"],
      uId: UniqueId,
      catagoryDescription: record["catagoryDescription"],
      createdOn: Timestamp.now(),
      parentName: record["parentName"]);

  Map<String, dynamic> toJson() => {
        "catagoryName": this.catagoryName,
        "catagoryDescription": this.catagoryDescription,
        "parentName": this.parentName,
        "createdOn": this.createdOn
      };

  @override
  String toString() {
    return 'Menu{catagoryName: $catagoryName, catagoryDescription: $catagoryDescription, parentName: $parentName, createdOn: $createdOn}';
  }
}
