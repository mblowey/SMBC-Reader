import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

extension QueryExtensions on DatabaseExecutor {
  Future<bool> exists(String tableName, {String where, List<dynamic> whereArgs}) async {
    final query = '''
      SELECT EXISTS (
        SELECT 1
        FROM ${escapeName(tableName)}
        ${_getClause('WHERE', where)}
        LIMIT 1
      );
    ''';

    final queryResult = await this.rawQuery(query, whereArgs);

    assert(queryResult.length == 1 && queryResult.first.values.length == 1);

    return (queryResult.first.values.first as int) == 0 ? false : true;
  }
}

String _getClause(String name, String clause) {
  if (clause != null) {
    return '$name $clause';
  }

  return '';
}