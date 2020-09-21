import 'package:flutter/material.dart';
import 'package:smbc_reader/widgets/comic_screen_drawer_header.dart';

import 'comic_list.dart';

class ComicScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ComicScreenDrawerHeader(),
              Expanded(
                child: ComicList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
