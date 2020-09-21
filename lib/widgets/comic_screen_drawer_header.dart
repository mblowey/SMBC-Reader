import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smbc_reader/blocs/comic_bloc/comic_bloc.dart';
import 'package:smbc_reader/data/comic_repository.dart';

enum _ActionMenuItems {
  markAllAsRead,
  markAllAsUnread,
}

class ComicScreenDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white38,
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Text("SMBC Comics", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25)),
          ),
          Spacer(),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.refresh,
              size: 30,
            ),
            onPressed: () => ComicBloc.of(context).add(RefreshComicList()),
          ),
//          IconButton(
//            color: Theme.of(context).primaryColor,
//            icon: Icon(
//              Icons.settings,
//              size: 30,
//            ),
//            onPressed: () {},
//          ),
          PopupMenuButton<_ActionMenuItems>(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Mark All As Read'),
                value: _ActionMenuItems.markAllAsRead,
              ),
              const PopupMenuItem(
                child: Text('Mark All As Unread'),
                value: _ActionMenuItems.markAllAsUnread,
              ),
            ],
            onSelected: (selection) {
              switch (selection) {
                case _ActionMenuItems.markAllAsRead:
                  ComicBloc.of(context).add(MarkAllAsRead());
                  break;

                case _ActionMenuItems.markAllAsUnread:
                  ComicBloc.of(context).add(MarkAllAsUnread());
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
