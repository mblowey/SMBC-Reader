import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:smbc_reader/blocs/comic_bloc/comic_bloc.dart';
import 'package:smbc_reader/data/comic_repository.dart';
import 'package:smbc_reader/data/image_repository.dart';
import 'package:smbc_reader/screens/comic_screen.dart';
import 'package:smbc_reader/utils/utils.dart';
import 'main.reflectable.dart';

void main() {
  initializeReflectable();

  runApp(
    Phoenix(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMBC Reader',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(Color(0xFF516A92)),
        accentColor: generateMaterialColor(Color(0xFFF89B69)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        dialogTheme: DialogTheme(
          contentTextStyle: TextStyle(
            fontSize: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ComicRepository>(
            lazy: false,
            create: (context) => ComicRepository(),
          ),
          RepositoryProvider<ImageRepository>(
            create: (context) => ImageRepository(),
          ),
        ],
        child: BlocProvider<ComicBloc>(
          lazy: false,
          create: (context) => ComicBloc(
            RepositoryProvider.of<ComicRepository>(context),
            RepositoryProvider.of<ImageRepository>(context),
          ),
          child: ComicScreen(),
        ),
      ),
    );
  }
}
