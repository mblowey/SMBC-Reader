import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smbc_reader/blocs/comic_bloc/comic_bloc.dart';
import 'package:smbc_reader/widgets/comic_screen_action_menu.dart';
import 'package:smbc_reader/widgets/comic_screen_drawer.dart';
import 'package:smbc_reader/widgets/comic_navigation_bar.dart';
import 'package:smbc_reader/widgets/comic_view.dart';

class ComicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: BlocBuilder<ComicBloc, ComicBlocState>(
          builder: (context, state) {
            return Text(state.name ?? '');
          },
        ),
        centerTitle: true,
        actions: [
          ComicScreenActionMenu(),
        ],
      ),
      body: ComicView(),
      bottomNavigationBar: ComicNavigationBar(),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floatingActionButton: ComicScreenFloatingButton(),
      drawer: ComicScreenDrawer(),
    );
  }
}
