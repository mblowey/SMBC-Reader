import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smbc_reader/blocs/comic_bloc/comic_bloc.dart';

import 'content_dialog.dart';

class ComicScreenFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicBloc, ComicBlocState>(
      builder: (context, state) {
        return Container(
          width: 80,
          child: RawMaterialButton(
            shape: StadiumBorder(),
            child: Image(image: AssetImage('lib/assets/smbc_assets/big_red_button.png')),
            onPressed: () async {
              if (state.afterImage != null) {
                await ContentDialog.show(
                  context: context,
                  transparent: true,
                  content: Image.memory(state.afterImage),
                );
              }
            },
          ),
        );
      },
    );
  }
}
