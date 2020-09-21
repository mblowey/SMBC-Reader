import 'package:meta/meta.dart';
import 'package:smbc_reader/models/model_base.dart';

import 'model_annotations.dart';

@dataReflectable
@Table(name: 'comic_order')
class ComicOrder extends ModelBase {

  @Column(name: 'name', type: ColumnType.Text)
  final String name;

  @Column(name: 'next_name', type: ColumnType.Text)
  final String nextName;

  @Column(name: 'previous_name', type: ColumnType.Text)
  final String previousName;

  const ComicOrder({
    @required this.name,
    @required this.nextName,
    @required this.previousName,
  });

  @override
  List<Object> get props => [name, nextName, previousName];
}
