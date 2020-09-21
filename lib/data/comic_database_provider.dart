import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smbc_reader/models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:smbc_reader/utils/utils.dart';
import 'package:sqflite/sql.dart';
import 'queries/creation_queries.dart';
import 'queries/misc_queries.dart';

class ComicDatabaseProvider {
  Database _db;
  String _dbPath;

  Future _init;

  Future get init => _init;

  ComicDatabaseProvider() {
    _init = _initialize();
  }

  Future<void> _initialize() async {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }

    var _dbPath = '${await getApplicationSupportDirectory()}/smbc_comic_database.sqlite';

    //await Sqflite.devSetDebugModeOn(true);

    _db = await openDatabase(
      _dbPath,
      version: 1,
      //onConfigure: (db) async => await db.execute("PRAGMA foreign_keys = ON"),
      onCreate: (db, version) async {
        //var creationScript = await rootBundle.loadString('lib/repositories/scripts/create_database.sql');
        await db.executeQueries(
          [createComicTableQuery, createComicOrderTableQuery, createComicDataTableQuery],
          asBatch: true,
        );
      },
    );
  }

  Future<void> resetDatabase() async {
    await _init;

    await File(_dbPath).delete();
    await File(_dbPath + '-journal').delete();

    await _db.close();

    _init = _initialize();
    await _init;
  }
  
  Future<void> deleteRecentComics() async {
    await _init;

    final fiveDaysAgo = DateTime.now().subtract(Duration(days: 5)).toUtc().millisecondsSinceEpoch;

    _db.delete(getTableName<Comic>(), where: 'publish_date > ?', whereArgs: [fiveDaysAgo]);
  }

  Future<Iterable<Comic>> getComicList() async {
    await _init;

    var queryResults = await _db.query(
      getTableName<Comic>(),
      columns: getColumnNames<Comic>(),
      orderBy: 'publish_date DESC',
    );

    return queryResults.map((r) => modelFromMap<Comic>(r));
  }

  Future<Comic> getComic(String comicName) async {
    await _init;

    var queryResults = await _db.query(
      getTableName<Comic>(),
      columns: getColumnNames<Comic>(),
      where: 'name = ?',
      whereArgs: [comicName],
      limit: 1,
    );

    return queryResults.map((r) => modelFromMap<Comic>(r)).firstOrNull();
  }

  Future<Comic> getLatestComic() async {
    await _init;

    var queryResult = await _db.query(
      getTableName<Comic>(),
      columns: getColumnNames<Comic>(),
      orderBy: 'publish_date DESC',
      limit: 1,
    );

    return queryResult.map((r) => modelFromMap<Comic>(r)).firstOrNull();
  }

  Future<Comic> getNextComic(String comicName) async {
    await _init;

    var order = await getComicOrder(comicName);
    if (order?.nextName == null) return null;

    return await getComic(order.nextName);
  }

  Future<Comic> getPreviousComic(String comicName) async {
    await _init;

    var order = await getComicOrder(comicName);
    if (order?.previousName == null) return null;

    return await getComic(order.previousName);
  }

  Future<Comic> getFirstComic() async {
    await _init;

    var queryResult = await _db.query(
      getTableName<Comic>(),
      columns: getColumnNames<Comic>(),
      orderBy: 'publish_date',
      limit: 1,
    );

    return queryResult.map((r) => modelFromMap<Comic>(r)).firstOrNull();
  }

  Future<Iterable<Comic>> markComicAsRead(String comicName) async {
    await _init;

    var batch = _db.batch();

    batch.update(
      getTableName<Comic>(),
      {'is_read': 1},
      where: 'name = ?',
      whereArgs: [comicName],
    );

    batch.query(
      getTableName<Comic>(),
      columns: getColumnNames<Comic>(),
      orderBy: 'publish_date DESC',
    );

    var queryResult = await batch.commit();
    var comicListMap = queryResult[1] as List<Map<String, dynamic>>;

    return comicListMap.map((r) => modelFromMap<Comic>(r));
  }

  Future<Iterable<Comic>> markAllAsRead() async {
    await _init;

    var batch = _db.batch();

    batch.update(
      getTableName<Comic>(),
      {'is_read': true},
    );

    batch.query(
      getTableName<Comic>(),
      columns: getColumnNames<Comic>(),
      orderBy: 'publish_date DESC',
    );

    var queryResult = await batch.commit();
    var comicListMap = queryResult[1] as List<Map<String, dynamic>>;

    return comicListMap.map((r) => modelFromMap<Comic>(r));
  }

  Future<Iterable<Comic>> markAllAsUnread() async {
    await _init;

    var batch = _db.batch();

    batch.update(
      getTableName<Comic>(),
      {'is_read': false},
    );

    batch.query(
      getTableName<Comic>(),
      columns: getColumnNames<Comic>(),
      orderBy: 'publish_date DESC',
    );

    var queryResult = await batch.commit();
    var comicListMap = queryResult[1] as List<Map<String, dynamic>>;

    return comicListMap.map((r) => modelFromMap<Comic>(r));
  }

  Future<void> insertComics(List<Comic> comics) async {
    assert(comics.length > 1, 'Current implementation assumes you are actually inserting multiple comics.');
    await _init;

    final comicTableName = getTableName<Comic>();
    final comicOrderTableName = getTableName<ComicOrder>();

    comics.sort((c1, c2) => c1.publishDate.compareTo(c2.publishDate));

    await _db.transaction((txn) async {
      var batch = txn.batch();

      for (var comic in comics) {
        batch.insert(
          comicTableName,
          comic.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      batch.delete(comicOrderTableName);

      // Insert special case of first comic. Doing this to keep branching out of for loop
      batch.insert(
        comicOrderTableName,
        ComicOrder(
          name: comics[0].name,
          nextName: comics[1].name,
          previousName: null,
        ).toMap(),
      );

      for (int i = 1; i < comics.length - 1; i++) {
        batch.insert(
          comicOrderTableName,
          ComicOrder(
            name: comics[i].name,
            nextName: comics[i + 1].name,
            previousName: comics[i - 1].name,
          ).toMap(),
        );
      }

      // Insert special case of last comic. Doing this to keep branching out of for loop
      batch.insert(
        comicOrderTableName,
        ComicOrder(
          name: comics[comics.length - 1].name,
          nextName: null,
          previousName: comics[comics.length - 2].name,
        ).toMap(),
      );

      await batch.commit(noResult: true);
    });

    assert(
      Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $comicTableName')) ==
          Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $comicOrderTableName')),
      'Got ${Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $comicTableName'))} comics and '
      '${Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $comicOrderTableName'))} comic_orders',
    );
  }

  Future<ComicData> getComicData(String comicName) async {
    await _init;

    var queryResults = await _db.query(
      getTableName<ComicData>(),
      columns: getColumnNames<ComicData>(),
      where: 'name = ?',
      whereArgs: [comicName],
      limit: 1,
    );

    return queryResults.map((r) => modelFromMap<ComicData>(r)).firstOrNull();
  }

  Future<bool> hasComicData(String comicName) async {
    await _init;

    final result = await _db.exists(
      getTableName<ComicData>(),
      where: 'name = ?',
      whereArgs: [comicName],
    );

    return result;
  }

  Future<void> insertComicData(ComicData comicData) async {
    await _init;

    await _db.insert(
      comicData.getTableName(),
      comicData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ComicOrder> getComicOrder(String comicName) async {
    await _init;

    var queryResult = await _db.query(
      getTableName<ComicOrder>(),
      columns: getColumnNames<ComicOrder>(),
      where: 'name = ?',
      whereArgs: [comicName],
      limit: 1,
    );

    return queryResult.map((r) => modelFromMap<ComicOrder>(r)).firstOrNull();
  }
}
