import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'online_event.dart';
part 'online_state.dart';

class OnlineBloc extends Bloc<OnlineEvent, OnlineState> {
  OnlineBloc() : super(Offline());
}
