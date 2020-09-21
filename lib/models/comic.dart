import 'package:meta/meta.dart';

import 'model_annotations.dart';
import 'model_base.dart';

@dataReflectable
@Table(name: 'comics')
class Comic extends ModelBase {

  @Column(name: 'name', type: ColumnType.Text)
  final String name;

  @Column(name: 'publish_date', type: ColumnType.Integer)
  final DateTime publishDate;

  @Column(name: 'is_read', type: ColumnType.Integer)
  final bool isRead;

  const Comic({
    @required this.name,
    @required this.publishDate,
    this.isRead = false
  });

  @override
  List<Object> get props => [name, publishDate, isRead];
}