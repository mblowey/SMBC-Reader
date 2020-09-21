import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'model_annotations.dart';
import 'model_base.dart';

@dataReflectable
@Table(name: 'comic_data')
class ComicData extends ModelBase {
  @Column(name: 'name', type: ColumnType.Text)
  final String name;

  @Column(name: 'alt_text', type: ColumnType.Text)
  final String altText;

  @Column(name: 'comic_image_url', type: ColumnType.Text)
  final String comicImageUrl;

  @Column(name: 'after_image_url', type: ColumnType.Text)
  final String afterImageUrl;

  const ComicData({
    @required this.name,
    @required this.altText,
    @required this.comicImageUrl,
    @required this.afterImageUrl,
  });

  @override
  List<Object> get props => [name, altText, comicImageUrl, afterImageUrl];
}
