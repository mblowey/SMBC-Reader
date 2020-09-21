import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:reflectable/reflectable.dart';

import 'model_annotations.dart';

class _ColumnMapping {
  final String memberName;
  final Type memberType;
  final String columnName;
  final ColumnType columnType;

  _ColumnMapping({
    @required this.memberName,
    @required this.memberType,
    @required this.columnName,
    @required this.columnType,
  });
}

abstract class ModelBase extends Equatable {
  const ModelBase();

  String getTableName() {
    var instanceMirror = dataReflectable.reflect(this);
    var classMirror = instanceMirror.type;

    var tableAnnotation = classMirror.metadata.firstWhere((m) => m is Table) as Table;
    return tableAnnotation.name;
  }

  List<String> getColumnNames() {
    var instanceMirror = dataReflectable.reflect(this);
    var classMirror = instanceMirror.type;

    var columns = List<String>();
    classMirror.declarations.forEach((name, decl) {
      var columnAnnotation = decl.metadata.firstWhere((m) => m is Column, orElse: () => null) as Column;

      if (columnAnnotation != null) {
        columns.add(columnAnnotation.name);
      }
    });

    return columns;
  }

  Map<String, dynamic> toMap() {
    var instanceMirror = dataReflectable.reflect(this);
    var classMirror = instanceMirror.type;

    // Get a list of _ColumnMappings so we can build the map by examining this object's values.
    var columns = _getColumnMapping(classMirror);

    // Build the value map by invoking the getter for each property marked with @Column
    // and add it to the map with the correct column name.
    var valueMap = Map<String, dynamic>();
    for (var column in columns) {
      var member = classMirror.instanceMembers[column.memberName];
      var memberType = member.reflectedReturnType;

      // Handle DateTime specially
      if (memberType == DateTime && column.columnType == ColumnType.Integer) {
        var dateTimeValue = instanceMirror.invokeGetter(column.memberName) as DateTime;
        if (!dateTimeValue.isUtc) dateTimeValue = dateTimeValue.toUtc();

        valueMap[column.columnName] = dateTimeValue.millisecondsSinceEpoch;
      }
      // Handle bool specially
      else if (memberType == bool && column.columnType == ColumnType.Integer) {
        var value = instanceMirror.invokeGetter(column.memberName) as bool;
        valueMap[column.columnName] = value ? 1 : 0;
      }
      // General case
      else {
        valueMap[column.columnName] = instanceMirror.invokeGetter(column.memberName);
      }
    }

    return valueMap;
  }
}

String getTableName<Model extends ModelBase>() {
  var classMirror = dataReflectable.reflectType(Model) as ClassMirror;

  var tableAnnotation = classMirror.metadata.firstWhere((m) => m is Table) as Table;
  return tableAnnotation.name;
}

List<String> getColumnNames<Model extends ModelBase>({Model m}) {
  var classMirror = dataReflectable.reflectType(Model) as ClassMirror;

  var columns = List<String>();
  classMirror.declarations.forEach((name, decl) {
    var columnAnnotation = decl.metadata.firstWhere((m) => m is Column, orElse: () => null) as Column;

    if (columnAnnotation != null) {
      columns.add(columnAnnotation.name);
    }
  });

  return columns;
}

Model modelFromMap<Model extends ModelBase>(Map<String, dynamic> valueMap) {
  if (valueMap == null || valueMap.values.every((v) => v == null)) return null;

  var classMirror = dataReflectable.reflectType(Model) as ClassMirror;
  var constructor = classMirror.declarations[classMirror.simpleName] as MethodMirror;

  var columns = _getColumnMapping(classMirror);

  var namedConstructorArgs = Map<Symbol, dynamic>();
  for (var column in columns) {
    // Handle DateTime specially
    if (column.memberType == DateTime && column.columnType == ColumnType.Integer) {
      var date = DateTime.fromMillisecondsSinceEpoch(valueMap[column.columnName], isUtc: true);
      namedConstructorArgs[Symbol(column.memberName)] = date;
    }
    // Handle bool specially
    else if (column.memberType == bool && column.columnType == ColumnType.Integer) {
      var intValue = valueMap[column.columnName] as int;
      namedConstructorArgs[Symbol(column.memberName)] = intValue == 0 ? false : true;
    }
    // General case
    else {
      namedConstructorArgs[Symbol(column.memberName)] = valueMap[column.columnName];
    }
  }

  return classMirror.newInstance(constructor.constructorName, [], namedConstructorArgs);
}

List<_ColumnMapping> _getColumnMapping(ClassMirror classMirror) {
  var columns = List<_ColumnMapping>();

  classMirror.declarations.forEach((name, decl) {
    var columnAnnotation = decl.metadata.firstWhere((m) => m is Column, orElse: () => null) as Column;

    if (columnAnnotation != null && decl is VariableMirror) {
      columns.add(
        _ColumnMapping(
          memberName: name,
          memberType: decl.reflectedType,
          columnName: columnAnnotation.name,
          columnType: columnAnnotation.type,
        ),
      );
    }
  });

  return columns;
}

//
//extension FromMapExtender on ModelBase {
//
//  ModelBase fromMap(Map<String, dynamic> valueMap) {
//
//  }
//
//}
