import 'package:business_book/manage_db/local_db.dart';
import 'package:business_book/manage_db/menu.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sembast/sembast.dart';

class MenuAction {
  String storeName;
  StoreRef<int, Map<String, dynamic>> _menuStore;

  MenuAction({this.storeName}) {
    _menuStore = intMapStoreFactory.store("store");
  }

  Future<Database> get _db async => await LocalDb.instance.getDb;

  Future<int> insert(Menu menu) async {
    return await this.findByName(menu.catagoryName).then((state) async {
      print('Status: $state');
      if (state == null || state == 0) {
        menu.catagoryName = menu.catagoryName.toUpperCase();
        return await _menuStore.add(await _db, menu.toJson()).then((result) {
          return result;
        });
      } else {
        return 0;
      }
    });
  }

  Future<int> findByName(String catagoryName) async {
    print("Searching for item: ${catagoryName}");
    Menu actualItem = null;
    return await _menuStore.find(await _db).then((result) {
      print("Total: ${result.length}");
      int i = 0;
      bool foundFlag = false;
      while (i < result.length) {
        if (result.elementAt(i)['catagoryName'] == catagoryName.toUpperCase()) {
          foundFlag = true;
          break;
        }
        i++;
      }

      if (foundFlag) {
        Fluttertoast.showToast(msg: "Folder already exists");
        return 1;
      } else {
        return 0;
      }
    });
  }

  Future<Menu> find(String catagoryName) async {
    print("Searching for item: ${catagoryName}");
    Menu actualItem = Menu();
    return await _menuStore.find(await _db).then((result) {
      print("Total: ${result.length}");
      int i = 0;
      bool foundFlag = false;
      while (i < result.length) {
        if (result.elementAt(i)['catagoryName'] == catagoryName.toUpperCase()) {
          foundFlag = true;
          actualItem =
              Menu.fromJson(result.elementAt(i).value, result.elementAt(i).key);
          break;
        }
        i++;
      }
      return actualItem;
    });
  }

  Future<int> updateMenu(Menu menu) async {
    print('Update record: ${menu.uId}');
    menu.catagoryName = menu.catagoryName.toUpperCase();
    final finder = Finder(filter: Filter.byKey(menu.uId));
    return await _menuStore
        .update(await _db, menu.toJson(), finder: finder)
        .then((result) {
      return result;
    });
  }

  Future delete(Menu menu) async {
    final finder = Finder(filter: Filter.byKey(menu.uId));
    print('Deleted object: $finder');
    await _menuStore.delete(await _db, finder: finder).then((value) {
      print('Deleting status: $value');
    });
  }

  Future<List<Menu>> getFullMenu() async {
    final recordSnapshot = await _menuStore.find(await _db);
    return recordSnapshot.map((snapshot) {
      final menus = Menu.fromJson(snapshot.value, snapshot.key);
      return menus;
    }).toList();
  }
}
