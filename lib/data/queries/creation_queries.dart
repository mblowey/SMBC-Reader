import 'package:sqflite/sqflite.dart';

extension DatabaseExtensions on DatabaseExecutor {
  Future<void> executeQueries(Iterable<String> queries, {Iterable<List<String>> arguments, bool asBatch}) async {
    assert(queries.isNotEmpty, 'queries cannot be null');
    assert(arguments == null || queries.length == arguments.length, 'Expected the same amount of queries and arguments or no arguments.');

    final queriesAndArgs = arguments == null
        ? Map.fromEntries(queries.map((q) => MapEntry(q, null)))
        : Map.fromIterables(queries, arguments);

    if (asBatch) {
      var batch = this.batch();
      queriesAndArgs.forEach((q, a) => batch.execute(q, a));
      await batch.commit(noResult: true);
    } else {
      queriesAndArgs.forEach((q, a) async => await execute(q, a));
    }
  }
}

const createComicTableQuery = r'''
CREATE TABLE comics (
  name TEXT NOT NULL UNIQUE,
  publish_date INTEGER NOT NULL,
  is_read INTEGER NOT NULL
);
''';

const createComicDataTableQuery = r'''
CREATE TABLE comic_data (
  name TEXT NOT NULL UNIQUE,
  alt_text TEXT NOT NULL,
  comic_image_url TEXT NOT NULL,
  after_image_url TEXT NOT NULL
);
''';

const createComicOrderTableQuery = r'''
CREATE TABLE comic_order (
  name TEXT NOT NULL UNIQUE,
  next_name TEXT UNIQUE,
  previous_name TEXT UNIQUE
);
''';
