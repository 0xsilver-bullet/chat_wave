part of 'online_bloc.dart';

abstract class OnlineState extends Equatable {
  const OnlineState();

  @override
  List<Object> get props => [];
}

class Online extends OnlineState {}

class Offline extends OnlineState {}
