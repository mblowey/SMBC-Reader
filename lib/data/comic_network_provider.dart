import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:smbc_reader/models/models.dart';
import 'package:smbc_reader/utils/utils.dart';

class ComicNetworkProvider {
  Future<ComicData> getComicData(String name) async {
    var document = await _getHtml('https://www.smbc-comics.com/comics/${toComicSlug(name)}');

    var comicImageUrl = document.querySelector('meta[property="og:image"]').attributes['content'];
    //var comicImage = await _getImage(comicImageUrl);

    var afterImageUrl = document.getElementById('aftercomic').children.firstOrNull()?.attributes?.valueFor('src');
    //var afterImage = await _getImage(afterImageUrl);

    var altText = document.getElementById('cc-comic').attributes['title'];

    return ComicData(
      name: name,
      altText: altText,
      comicImageUrl: comicImageUrl,
      afterImageUrl: afterImageUrl,
    );
  }

  Future<Iterable<Comic>> getComicList() async {
    var document = await _getHtml('https://www.smbc-comics.com/comic/archive');

    var comicOptions = document.querySelector('select[name="comic"]').children;

    // Reverse the options so the most recent comic is first, filter out any non-comic options, then parse out
    // the actual name and publish date values.
    return comicOptions.reversed.where((option) => !option.text.startsWith('Select a comic')).map((option) {
      var dateAndName = option.text.split(' - ');
      assert(dateAndName.length == 2, 'Got bad results when splitting comic option text.');

      // Parses out dates in the format 'July 07, 2020
      var date = DateFormat.yMMMMd('en_US').parse(dateAndName[0], true);
      assert(date != null, 'Failed to parse date');

      var name = dateAndName[1];

      // The comic name is not always unique, but the comic slug is.
      var slugName = option.attributes.valueFor('value').replaceFirst('comic/', '');

      // We use the name and slug together to come up with an accurate-as-possible name that still
      // looks pretty. Note that whatever name we come up with must be convertible back
      // to the comic slug.
      name = getCompleteComicName(name, slugName);
      assert(toComicSlug(name) == slugName);

      return Comic(
        name: name,
        publishDate: date,
      );
    });
  }

  Future<Document> _getHtml(String url) async {
    var client = HttpClient();

    var request = await client.getUrl(Uri.parse(url));
    var response = await request.close();

    var htmlContent = await response.transform(utf8.decoder).join();

    return parse(htmlContent);
  }

  Future<Uint8List> _getImage(String url) async {
    var client = HttpClient();

    var request = await client.getUrl(Uri.parse(url));
    var response = await request.close();

    return await consolidateHttpClientResponseBytes(response, autoUncompress: true);
  }
}

//ComicData getComicData(String name)  {
//  final networkProvider = ComicNetworkProvider();
//
//  return null;// await networkProvider.getComicData(name);
//}

