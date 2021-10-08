part of 'player_bloc.dart';

@immutable
abstract class PlayerEvent {}

class PlayEvent extends PlayerEvent {
  final String url;
  PlayEvent({required this.url});
}

class PauseEvent extends PlayerEvent {}

