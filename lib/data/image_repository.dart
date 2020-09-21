import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class ImageRepository extends BaseCacheManager {
  static ImageRepository _instance;

  factory ImageRepository({String storageDir}) {
    if (_instance == null) _instance = ImageRepository._();

    return _instance;
  }

  static const _cacheKey = 'image_file_provider_key';
  static const _maxAge = Duration(days: 365);
  static const _maxCacheSize = 100;

  ImageRepository._()
      : super(
          _cacheKey,
          maxAgeCacheObject: _maxAge,
          maxNrOfCacheObjects: _maxCacheSize,
        );

  @override
  Future<String> getFilePath() async {
    var dir = await getApplicationSupportDirectory();
    return '${dir.path}/$_cacheKey';
  }

  Future<Uint8List> getImageBytes(String imageUrl) async {
    var imageFile = await getSingleFile(imageUrl);

    return await imageFile.readAsBytes();
  }
}
