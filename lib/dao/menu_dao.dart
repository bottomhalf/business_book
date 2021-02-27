import 'package:business_book/manage_db/local_db.dart';
import 'package:business_book/manage_db/menu.dart';
import 'package:sembast/sembast.dart';

class MenuAction {
  String catagoryName;
  StoreRef<int, Map<String, dynamic>> _menuStore;

  MenuAction({this.catagoryName}) {
    _menuStore = intMapStoreFactory.store(this.catagoryName);
  }

  Future<Database> get _db async => await LocalDb.instance.getDb;

  Future<int> insert(Menu menu) async {
    return await _menuStore.add(await _db, menu.toJson()).then((result) {
      return result;
    });
  }

  Future updateBooks(Menu menu) async {
    final finder = Finder(filter: Filter.byKey(menu.catagoryName));
    await _menuStore.update(await _db, menu.toJson(), finder: finder);
  }

  Future delete(Menu books) async {
    final finder = Finder(filter: Filter.byKey(books.catagoryName));
    print('Deleted object: $finder');
    await _menuStore.delete(await _db, finder: finder).then((value) {
      print('Deleting status: $value');
    });
  }

  Future<List<Menu>> getFullMenu() async {
    final recordSnapshot = await _menuStore.find(await _db);
    return recordSnapshot.map((snapshot) {
      final menus = Menu.fromJson(snapshot.value);
      return menus;
    }).toList();
  }
}