import 'package:bloc/bloc.dart';
import 'package:chat_wave/setting/domain/repository/profile_repository.dart';
import 'package:chat_wave/utils/blocs/app_bloc/app_bloc.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'name_event.dart';
part 'name_state.dart';

class NameBloc extends Bloc<NameEvent, NameState> {
  NameBloc(this.name, this._appBloc) : super(DefaultNameState(name)) {
    on<EditUserName>(_handleEditUserNameEvent);
    on<FinishedNameChange>(_handleFinishedNameChangeEvent);
  }

  final profileRepository = locator<ProfileRepository>();

  final String name;
  final AppBloc _appBloc;

  Future<void> _handleEditUserNameEvent(
    EditUserName event,
    Emitter<NameState> emit,
  ) async {
    if (event.newName.isEmpty) {
      emit(FailedToUpdateUserName(state.name));
      return;
    }
    emit(
      UpdatingUserName(
        oldName: state.name,
        newName: event.newName,
      ),
    );
    try {
      final newUserInfo = await profileRepository.updateProfile(
        event.newName,
        null,
      );
      emit(UpdatedUserName(newUserInfo.name));
      _appBloc.add(UserInfoChanged(newUserInfo));
    } catch (e) {
      emit(FailedToUpdateUserName(state.name));
    }
  }

  Future<void> _handleFinishedNameChangeEvent(
    FinishedNameChange event,
    Emitter<NameState> emit,
  ) async {
    emit(DefaultNameState(state.name));
  }
}
