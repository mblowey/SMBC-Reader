import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smbc_reader/models/models.dart';

class ComicBlocState extends Equatable {
  final List<Comic> comicList;
  final String name;
  final String altText;
  final Uint8List comicImage;
  final Uint8List afterImage;
  final bool hasNext;
  final bool hasPrevious;

  ComicBlocState({
    @required this.name,
    @required this.altText,
    @required this.comicImage,
    @required this.afterImage,
    @required this.hasNext,
    @required this.hasPrevious,
    @required this.comicList,
  });

  ComicBlocState.empty()
      : this(
          name: null,
          altText: null,
          comicImage: null,
          afterImage: null,
          hasNext: false,
          hasPrevious: false,
          comicList: null,
        );

  ComicBlocState.from(ComicBlocState other)
      : this(
          name: other.name,
          altText: other.altText,
          comicImage: other.comicImage,
          afterImage: other.afterImage,
          hasNext: other.hasNext,
          hasPrevious: other.hasPrevious,
          comicList: other.comicList,
        );

  @override
  List<Object> get props => [
        name,
        altText,
        comicImage,
        afterImage,
        hasNext,
        hasPrevious,
        comicList,
      ];

  ComicBlocState updateWith({
    String name,
    String altText,
    Uint8List comicImage,
    Uint8List afterImage,
    bool hasNext,
    bool hasPrevious,
    List<Comic> comicList,
  }) {
    return ComicBlocState(
      name: name ?? this.name,
      altText: altText ?? this.altText,
      comicImage: comicImage ?? this.comicImage,
      afterImage: afterImage ?? this.afterImage,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      comicList: comicList ?? this.comicList,
    );
  }

  ComicBlocState nullComicData({bool hasNext = true, bool hasPrevious = true}) {
    return ComicBlocState(
      name: null,
      altText: null,
      comicImage: null,
      afterImage: null,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
      comicList: comicList,
    );
  }
}
