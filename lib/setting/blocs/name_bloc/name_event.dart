part of 'name_bloc.dart';

@immutable
abstract class NameEvent extends Equatable {
  const NameEvent();

  @override
  List<Object> get props => [];
}

@immutable
class EditUserName extends NameEvent {
  const EditUserName(this.newName);

  final String newName;

  @override
  List<Object> get props => [newName];
}

class FinishedNameChange extends NameEvent {}
