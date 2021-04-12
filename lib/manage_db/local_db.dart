import 'dart:async';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalDb {
  Completer<Database> dbComplete;
  static final LocalDb _instance = LocalDb._internal();

  LocalDb._internal();

  static LocalDb get instance => _instance;

  Future<Database> get getDb async {
    if (dbComplete == null) {
      dbComplete = Completer();
      if (dbComplete != null) setUpDb();
    }
    return dbComplete.future;
  }

  Future<void> setUpDb() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbpath = p.join(dir.path, 'bh_shop.db');
    print('Db path: ${dbpath}');

    final database = await databaseFactoryIo.openDatabase(dbpath);
    if (dbComplete == null) dbComplete = Completer();
    dbComplete.complete(database);
  }
}
