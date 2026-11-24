import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:oc_demo/models/base_model.dart';

import '../../accountInfo/bloc/account_info_repository.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  AccountInfoRepositoryImp? repository;
  ChangePasswordBloc({this.repository}) : super(ChangePasswordInitial()) {
    on<ChangePasswordEvent>(mapEventToState);
  }
  void mapEventToState(
  ChangePasswordEvent event, Emitter<ChangePasswordState> emit) async{
    if (event is ChangePassword) {
      emit(ChangePasswordInitial());
      try {
        var model = await repository?.editPassword( event.old_password,event.new_password);
        if (model != null) {
          emit(ChangePasswordSuccess(model));
        } else {
          emit(ChangePasswordError());
        }
      } catch (error, _) {
        print(error.toString());
        emit(ChangePasswordError());
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    }
  }
}
