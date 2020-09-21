import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smbc_reader/blocs/comic_bloc/comic_bloc.dart';
import 'package:smbc_reader/widgets/loading_dialog.dart';

import 'content_dialog.dart';

class ComicNavigationBar extends StatelessWidget {
  Widget _getFirstComicButton(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      color: Theme
          .of(context)
          .primaryColor,
      icon: Image(image: AssetImage('lib/assets/smbc_assets/first.png')),
      onPressed: () {
        ComicBloc.of(context).add(FirstComic());
      },
    );
  }

  Widget _getPreviousComicButton(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(6),
      color: Theme
          .of(context)
          .primaryColor,
      icon: Image(image: AssetImage('lib/assets/smbc_assets/prev.png')),
      onPressed: () {
        ComicBloc.of(context).add(PreviousComic());
      },
    );
  }

  Widget _getNextComicButton(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(6),
      color: Theme
          .of(context)
          .primaryColor,
      icon: Image(image: AssetImage('lib/assets/smbc_assets/next.png')),
      onPressed: () {
        ComicBloc.of(context).add(NextComic());
      },
    );
  }

  Widget _getLatestComicButton(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      color: Theme
          .of(context)
          .primaryColor,
      icon: Image(image: AssetImage('lib/assets/smbc_assets/last.png')),
      onPressed: () {
        ComicBloc.of(context).add(LatestComic());
      },
    );
  }

  Widget _getFiller() {
    return IconButton(
      color: Colors.transparent,
      icon: Icon(Icons.cloud_circle),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicBloc, ComicBlocState>(
      builder: (context, state) {
        assert(state != null);

        final firstComicButton = state.hasPrevious ? _getFirstComicButton(context) : _getFiller();
        final previousComicButton = state.hasPrevious ? _getPreviousComicButton(context) : _getFiller();
        final nextComicButton = state.hasNext ? _getNextComicButton(context) : _getFiller();
        final latestComicButton = state.hasNext ? _getLatestComicButton(context) : _getFiller();

        return Container(
          //height: 60,
          decoration: BoxDecoration(color: Theme
              .of(context)
              .primaryColorLight, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              firstComicButton,
              previousComicButton,
              BlocBuilder<ComicBloc, ComicBlocState>(builder: (context, state) {
                return IconButton(
                  iconSize: 60,
                  padding: EdgeInsets.zero,
                  icon: Image(image: AssetImage('lib/assets/smbc_assets/big_red_button.png')),
                  onPressed: () async {
                    if (state.afterImage != null) {
                      await ContentDialog.show(
                        context: context,
                        transparent: true,
                        content: Image.memory(state.afterImage),
                      );
                    }
                  },
                );
              }),

              nextComicButton,
              latestComicButton,
            ],
          ),
        );
      },
    );
  }
}
