export 'comic_bloc_event.dart';
export 'comic_bloc_state.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smbc_reader/data/comic_repository.dart';
import 'package:smbc_reader/data/image_repository.dart';
import 'package:smbc_reader/models/models.dart';

import 'comic_bloc_state.dart';
import 'comic_bloc_event.dart';

class ComicBloc extends Bloc<ComicBlocEvent, ComicBlocState> {
  factory ComicBloc.of(BuildContext context) => BlocProvider.of<ComicBloc>(context);

  final ComicRepository _comicRepo;
  final ImageRepository _imageRepo;
  FutureOr<SharedPreferences> _sharedPrefs;

  ComicBloc(this._comicRepo, this._imageRepo) : super(ComicBlocState.empty()) {
    _sharedPrefs = SharedPreferences.getInstance();
    add(InitializeComicBloc());
  }

  @override
  Stream<ComicBlocState> mapEventToState(ComicBlocEvent event) async* {
    if (event is InitializeComicBloc) {
      yield* _mapInitializeComicBlocToState();
    } else if (event is RunDatabaseDebugScenario) {
      yield* _mapRunDatabaseDebugScenarioToState();
    } else if (event is RefreshComicList) {
      yield* _mapRefreshComicListToState();
    } else if (event is LatestComic) {
      yield* _mapLatestComicToState();
    } else if (event is NextComic) {
      yield* _mapNextComicToState(state.name);
    } else if (event is PreviousComic) {
      yield* _mapPreviousComicToState(state.name);
    } else if (event is FirstComic) {
      yield* _mapFirstComicToState();
    } else if (event is MarkAllAsRead) {
      yield* _mapMarkAllAsReadToState();
    } else if (event is MarkAllAsUnread) {
      yield* _mapMarkAllAsUnreadToState();
    } else if (event is ComicSelected) {
      yield* _mapComicSelectedToState(event.comicName);
    }

    await (await _sharedPrefs).setString('last_viewed_comic_name', state.name);
  }

  Stream<ComicBlocState> _mapRunDatabaseDebugScenarioToState() async* {
    await _comicRepo.runDatabaseDebugScenario();

    yield state.updateWith(comicList: _comicRepo.comicList);
  }

  Stream<ComicBlocState> _mapInitializeComicBlocToState() async* {
    yield state.nullComicData();

    var comicName = (await _sharedPrefs).getString('last_viewed_comic_name');

    var comicData = comicName != null
        ? await _comicRepo.getComicData(comicName) // Load the last-viewed comic
        : await _comicRepo.getLatestComicData(); // Fallback to latest comic

    yield ComicBlocState(
      name: comicData.name,
      altText: comicData.altText,
      comicImage: await _imageRepo.getImageBytes(comicData.comicImageUrl),
      afterImage: await _imageRepo.getImageBytes(comicData.afterImageUrl),
      hasNext: await _comicRepo.hasNextComic(comicName),
      hasPrevious: await _comicRepo.hasPreviousComic(comicName),
      comicList: _comicRepo.comicList,
    );
  }

  Stream<ComicBlocState> _mapRefreshComicListToState() async* {
    yield state.updateWith(comicList: List<Comic>.empty());

    await _comicRepo.refreshComicList();

    yield state.updateWith(comicList: _comicRepo.comicList);
  }

  Stream<ComicBlocState> _mapLatestComicToState() async* {
    yield state.nullComicData(hasNext: false);

    var comicData = await _comicRepo.getLatestComicData();

    yield ComicBlocState(
      name: comicData.name,
      altText: comicData.altText,
      comicImage: await _imageRepo.getImageBytes(comicData.comicImageUrl),
      afterImage: await _imageRepo.getImageBytes(comicData.afterImageUrl),
      hasNext: false,
      hasPrevious: true,
      comicList: _comicRepo.comicList,
    );
  }

  Stream<ComicBlocState> _mapNextComicToState(String currentComicName) async* {
    if (!state.hasNext) {
      yield ComicBlocState.from(state);
      return;
    }

    yield state.nullComicData();

    var nextComicData = await _comicRepo.getNextComicData(currentComicName);
    if (nextComicData == null) return;

    yield ComicBlocState(
      name: nextComicData.name,
      altText: nextComicData.altText,
      comicImage: await _imageRepo.getImageBytes(nextComicData.comicImageUrl),
      afterImage: await _imageRepo.getImageBytes(nextComicData.afterImageUrl),
      hasNext: await _comicRepo.hasNextComic(nextComicData.name),
      hasPrevious: true,
      comicList: _comicRepo.comicList,
    );
  }

  Stream<ComicBlocState> _mapPreviousComicToState(String currentComicName) async* {
    if (!state.hasPrevious) {
      yield ComicBlocState.from(state);
      return;
    }

    yield state.nullComicData();

    var previousComicData = await _comicRepo.getPreviousComicData(currentComicName);
    if (previousComicData == null) return;

    yield ComicBlocState(
      name: previousComicData.name,
      altText: previousComicData.altText,
      comicImage: await _imageRepo.getImageBytes(previousComicData.comicImageUrl),
      afterImage: await _imageRepo.getImageBytes(previousComicData.afterImageUrl),
      hasNext: true,
      hasPrevious: await _comicRepo.hasPreviousComic(previousComicData.name),
      comicList: _comicRepo.comicList,
    );
  }

  Stream<ComicBlocState> _mapFirstComicToState() async* {
    yield state.nullComicData(hasPrevious: false);

    var comicData = await _comicRepo.getFirstComicData();

    yield ComicBlocState(
      name: comicData.name,
      altText: comicData.altText,
      comicImage: await _imageRepo.getImageBytes(comicData.comicImageUrl),
      afterImage: await _imageRepo.getImageBytes(comicData.afterImageUrl),
      hasNext: true,
      hasPrevious: false,
      comicList: _comicRepo.comicList,
    );
  }

  Stream<ComicBlocState> _mapMarkAllAsReadToState() async* {
    await _comicRepo.markAllAsRead();
    yield state.updateWith(comicList: _comicRepo.comicList);
  }

  Stream<ComicBlocState> _mapMarkAllAsUnreadToState() async* {
    await _comicRepo.markAllAsUnread();
    yield state.updateWith(comicList: _comicRepo.comicList);
  }

  Stream<ComicBlocState> _mapComicSelectedToState(String comicName) async* {
    yield state.nullComicData();

    var comicData = await _comicRepo.getComicData(comicName);

    yield ComicBlocState(
      name: comicData.name,
      altText: comicData.altText,
      comicImage: await _imageRepo.getImageBytes(comicData.comicImageUrl),
      afterImage: await _imageRepo.getImageBytes(comicData.afterImageUrl),
      hasNext: await _comicRepo.hasNextComic(comicName),
      hasPrevious: await _comicRepo.hasPreviousComic(comicName),
      comicList: _comicRepo.comicList,
    );
  }
}
