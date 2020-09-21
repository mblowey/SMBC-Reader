import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:smbc_reader/blocs/comic_bloc/comic_bloc.dart';
import 'package:smbc_reader/widgets/loading_dialog.dart';

import 'comic_list_tile.dart';

class ComicList extends StatelessWidget {
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _scrollItemPositions = ItemPositionsListener.create();
  bool _initHandled = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicBloc, ComicBlocState>(
      builder: (context, state) {
        if (state.comicList != null && state.comicList.isNotEmpty) {
          var selectedIndex = state.comicList.indexWhere((comic) => comic.name == state.name);
          _scrollItemPositions.itemPositions.addListener(_setInitialScrollCallback(selectedIndex));

          return ScrollablePositionedList.separated(
            key: PageStorageKey('drawer_comic_list'),
            itemScrollController: _scrollController,
            itemPositionsListener: _scrollItemPositions,
            itemCount: state.comicList.length,
            itemBuilder: (context, index) {
              return ComicListTile(
                state.comicList[index],
                state.comicList[index].name == state.name,
              );
            },
            separatorBuilder: (context, index) {
              return _divider;
            },
          );
        } else {
          return LoadingDialog('Loading Comic List');
        }
      },
    );
  }

  // Returns a VoidCallback that ensures the selected comic's list item is always in
  // view when opening the list view.
  VoidCallback _setInitialScrollCallback(int selectedIndex) => () {
        if (_initHandled || !_scrollController.isAttached) return;
        _initHandled = true; // Only correct the view once

        final positions = _scrollItemPositions.itemPositions.value;

        final selectedPosition = positions.firstWhere((p) => p.index == selectedIndex, orElse: () => null);

        // If the selected comic is in view
        if (selectedPosition != null) {
          // If the selected comic's list entry is partially cut off, move it back into view
          if (selectedPosition.itemLeadingEdge < 0) {
            _scrollController.jumpTo(index: selectedIndex, alignment: 0.1);
          } else if (selectedPosition.itemTrailingEdge > 1.0) {
            _scrollController.jumpTo(index: selectedIndex, alignment: 0.8);
          }
        } else {
          // If the selected comic is not in view at all, scroll the list so that it is in view.
          if (selectedIndex < positions.first.index) {
            _scrollController.jumpTo(index: selectedIndex, alignment: 0.1);
          } else if (selectedIndex > positions.last.index) {
            _scrollController.jumpTo(index: selectedIndex, alignment: 0.8);
          } else {
            assert(false, "Should not reach here");
          }
        }
      };
}

final Widget _divider = Divider(
  height: 1,
  indent: 16,
  endIndent: 16,
);
