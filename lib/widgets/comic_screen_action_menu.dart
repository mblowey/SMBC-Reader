import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:share/share.dart';
import 'package:smbc_reader/blocs/comic_bloc/comic_bloc.dart';
import 'package:smbc_reader/data/comic_repository.dart';
import 'package:smbc_reader/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'confirm_dialog.dart';

enum _ActionMenuItems {
  openInBrowser,
  share,
  resetState,
  deleteDatabase,
}

class ComicScreenActionMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicBloc, ComicBlocState>(builder: (context, state) {
      return PopupMenuButton<_ActionMenuItems>(
        offset: Offset(0, 8),
        itemBuilder: (context) => [
          const PopupMenuItem(
            child: Text('Open in browser'),
            value: _ActionMenuItems.openInBrowser,
          ),
          const PopupMenuItem(
            child: Text('Share'),
            value: _ActionMenuItems.share,
          ),
          if (kDebugMode) ..._debugMenuItems,
        ],
        onSelected: (selection) async {
          switch (selection) {
            case _ActionMenuItems.openInBrowser:
              if (state.name != null)
                await launch('https://smbc-comics.com/comic/${toComicSlug(state.name)}');
              break;

            case _ActionMenuItems.share:
              if (state.name != null)
                Share.share('https://smbc-comics.com/comic/${toComicSlug(state.name)}');
              break;

            case _ActionMenuItems.resetState:
              Phoenix.rebirth(context);
              break;

            case _ActionMenuItems.deleteDatabase:
              final runDatabaseDebug = await showConfirmDialog(context, message: 'Run Database Debug Scenario?');

              if (runDatabaseDebug) {
                ComicBloc.of(context).add(RunDatabaseDebugScenario());
                //Phoenix.rebirth(context);
              }

              break;
          }
        },
      );
    });
  }
}

final _debugMenuItems = [
  const PopupMenuItem(
    child: Text('Reset State'),
    value: _ActionMenuItems.resetState,
  ),
  const PopupMenuItem(
    child: Text('Run Debug Database Scenario'),
    value: _ActionMenuItems.deleteDatabase,
  ),
];
