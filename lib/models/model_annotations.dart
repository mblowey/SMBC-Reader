import 'package:meta/meta.dart';
import 'package:reflectable/reflectable.dart';

enum ColumnType {
  Integer,
  Text,
  Real,
  Blob,
}

class Table {
  final String name;

  const Table({
    @required this.name,
  });
}

class Column {
  final String name;
  final ColumnType type;

  const Column({
    @required this.name,
    @required this.type,
  });
}

class DataReflectable extends Reflectable {
  const DataReflectable()
      : super(
          typeCapability,
          metadataCapability,
          declarationsCapability,
          instanceInvokeCapability,
          reflectedTypeCapability,
          newInstanceCapability,
        );
}

const dataReflectable = const DataReflectable();
