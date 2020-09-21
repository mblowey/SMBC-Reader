import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smbc_reader/blocs/comic_bloc/comic_bloc.dart';
import 'package:smbc_reader/widgets/loading_dialog.dart';

import 'content_dialog.dart';

class ComicView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<ComicBloc, ComicBlocState>(
          builder: (context, state) {
            if (state.comicImage != null) {
              return Center(
                child: GestureDetector(
                  child: SingleChildScrollView(
                    child: Container(
                      //color: Colors.green,
                      //padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                      child: Image.memory(state.comicImage),
                    ),
                  ),
                  onLongPress: () async => await ContentDialog.show(
                    context: context,
                    content: Text(
                      state.altText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).dialogTheme.contentTextStyle,
                    ),
                  ),
                  onHorizontalDragEnd: (dragDetails) {
                    if (dragDetails.primaryVelocity > 1000) {
                      ComicBloc.of(context).add(PreviousComic());
                    } else if (dragDetails.primaryVelocity < -1000) {
                      ComicBloc.of(context).add(NextComic());
                    }
                  },
                ),
              );
            } else {
              return LoadingDialog('Loading Comic');
            }
          },
        ),
      ],
    );
  }
}
