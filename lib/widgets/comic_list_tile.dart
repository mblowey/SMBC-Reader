import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smbc_reader/blocs/comic_bloc/comic_bloc.dart';
import 'package:smbc_reader/models/models.dart';

typedef OnComicTapped = void Function(Comic);

class ComicListTile extends StatelessWidget {
  final Comic _comic;
  final bool _isSelected;
  final OnComicTapped onComicTapped;

  ComicListTile(this._comic, this._isSelected, {this.onComicTapped});

  @override
  Widget build(BuildContext context) {
    final TextStyle comicNameStyle = TextStyle(
        color: Theme.of(context).textTheme.headline1.color,
        //fontSize: 18.0,
        fontSize: 16.0);
    final TextStyle comicUnreadNameStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      //fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
      fontSize: 17.0,
    );

    return Container(
      color: _isSelected ? Theme.of(context).primaryColorLight : null,
      child: ListTile(
        dense: true,
        title: Text(
          _comic.name,
          style: _comic.isRead ? comicNameStyle : comicUnreadNameStyle,
        ),
        trailing: Text(
          DateFormat.yMd('en_US').format(_comic.publishDate),
        ),
        onTap: () {
          onComicTapped?.call(_comic);
          ComicBloc.of(context).add(ComicSelected(_comic.name));
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
