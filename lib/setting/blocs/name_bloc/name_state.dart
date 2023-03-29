part of 'name_bloc.dart';

@immutable
abstract class NameState extends Equatable {
  const NameState(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

// Used to show the name loaded from the storage.
@immutable
class DefaultNameState extends NameState {
  const DefaultNameState(String name) : super(name);
}

@immutable
class UpdatingUserName extends NameState {
  const UpdatingUserName({required this.oldName, required this.newName})
      : super(oldName);

  final String oldName;
  final String newName;

  @override
  List<Object> get props => [oldName, newName];
}

@immutable
class FailedToUpdateUserName extends NameState {
  const FailedToUpdateUserName(String oldName) : super(oldName);
}

@immutable
class UpdatedUserName extends NameState {
  const UpdatedUserName(String newName) : super(newName);
}
