import 'dart:typed_data';

import 'package:smbc_reader/models/models.dart';
import 'package:smbc_reader/data/comic_database_provider.dart';
import 'package:smbc_reader/data/comic_network_provider.dart';


class ComicRepository {
  final ComicDatabaseProvider _databaseProvider = ComicDatabaseProvider();
  final ComicNetworkProvider _networkProvider = ComicNetworkProvider();

  Future _init;

  List<Comic> _comics;
  Iterable<Comic> get comicList => _comics;

  ComicRepository() {
    _init = _initialize();
  }

  Future<void> _initialize() async {
    _comics = List.of(await _databaseProvider.getComicList());

    if (_comics.isEmpty || DateTime.now().difference(_comics.first.publishDate) > Duration(days: 1)){
      await refreshComicList();
    }
  }

  // Triggers some test on the database. Changes arbitrarily since its for debug purposes.
  Future<void> runDatabaseDebugScenario() async {
    await _init;

//    await _databaseProvider.resetDatabase();
//    _init = _initialize();
    await _databaseProvider.deleteRecentComics();

    _comics = List.of(await _databaseProvider.getComicList());
  }

  Future<void> refreshComicList() async {
    var comicList = List.of(await _networkProvider.getComicList());

    await _databaseProvider.insertComics(comicList);

    _comics = List.of(await _databaseProvider.getComicList());
  }

  Future<ComicData> getComicData(String comicName) async {
    assert(comicName != null && comicName.isNotEmpty, "ComicRepository must have a name to retrieve the comic.");

    await _init;

    var comicData = await _databaseProvider.getComicData(comicName);

    if (comicData == null) {
      comicData = await _networkProvider.getComicData(comicName);
      await _databaseProvider.insertComicData(comicData);
    }

    await _markComicAsRead(comicData.name);
    return comicData;
  }

  Future<ComicData> getLatestComicData() async {
    await _init;

    var comic = await _databaseProvider.getLatestComic();
    var comicData = await _databaseProvider.getComicData(comic.name);

    if (comicData == null) {
      comicData = await _networkProvider.getComicData(comic.name);
      await _databaseProvider.insertComicData(comicData);
    }

    await _markComicAsRead(comic.name);
    return comicData;
  }

  Future<ComicData> getNextComicData(String currentComicName) async {
    await _init;

    var nextComic = await _databaseProvider.getNextComic(currentComicName);
    var nextComicData = await _databaseProvider.getComicData(nextComic.name);

    if (nextComicData == null) {
      nextComicData = await _networkProvider.getComicData(nextComic.name);
      await _databaseProvider.insertComicData(nextComicData);
    }

    await _markComicAsRead(nextComic.name);
    return nextComicData;
  }

  Future<ComicData> getPreviousComicData(String currentComicName) async {
    await _init;

    var prevComic = await _databaseProvider.getPreviousComic(currentComicName);
    var prevComicData = await _databaseProvider.getComicData(prevComic.name);

    if (prevComicData == null) {
      prevComicData = await _networkProvider.getComicData(prevComic.name);
      await _databaseProvider.insertComicData(prevComicData);
    }

    await _markComicAsRead(prevComic.name);
    return prevComicData;
  }

  Future<ComicData> getFirstComicData() async {
    await _init;

    var comic = await _databaseProvider.getFirstComic();
    var comicData = await _databaseProvider.getComicData(comic.name);

    if (comicData == null) {
      comicData = await _networkProvider.getComicData(comic.name);
      await _databaseProvider.insertComicData(comicData);
    }

    await _markComicAsRead(comic.name);
    return comicData;
  }

  Future<void> markAllAsRead() async {
    await _init;

    await _databaseProvider.markAllAsRead();
    _comics = List.of(await _databaseProvider.getComicList());
  }

  Future<void> markAllAsUnread() async {
    await _init;

    await _databaseProvider.markAllAsUnread();
    _comics = List.of(await _databaseProvider.getComicList());
  }

  Future<bool> hasNextComic(String comicName) async {
    await _init;

    return _comics.first.name != comicName;
  }

  Future<bool> hasPreviousComic(String comicName) async {
    await _init;

    return _comics.last.name != comicName;
  }

  Future<void> _markComicAsRead(String comicName) async {
    await _init;

    _comics = List.of(await _databaseProvider.markComicAsRead(comicName));
  }

//  Future<void> _preloadComicData(String comicName) async {
//    if (!await _databaseProvider.hasComicData(comicName)) {
//      final comicData = await compute( getComicData, comicName);
//      await _databaseProvider.insertComicData(comicData);
//    }
//  }
//
//  Future<void> _preloadNeighbors(String comicName) async {
//    final order = await _databaseProvider.getComicOrder(comicName);
//    await _preloadComicData(order.previousName);
//  }
}