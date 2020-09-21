import 'package:equatable/equatable.dart';


abstract class ComicBlocEvent extends Equatable {
  const ComicBlocEvent();

  @override
  List<Object> get props => [];
}

class InitializeComicBloc extends ComicBlocEvent {}

class RunDatabaseDebugScenario extends ComicBlocEvent {}

class RefreshComicList extends ComicBlocEvent {}

class LatestComic extends ComicBlocEvent {}

class NextComic extends ComicBlocEvent {}

class PreviousComic extends ComicBlocEvent {}

class FirstComic extends ComicBlocEvent {}

class MarkAllAsRead extends ComicBlocEvent {}

class MarkAllAsUnread extends ComicBlocEvent {}

class ComicSelected extends ComicBlocEvent {
  final String comicName;

  ComicSelected(this.comicName);

  @override List<Object> get props => [comicName];
}
