import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/loginModel/login_model.dart';
import 'package:oc_demo/models/registerAccountModel/register_account_model.dart';
import 'package:oc_demo/screens/login_signup/bloc/signin_signup_screen_repository.dart';

import '../../../models/base_model.dart';

part 'signin_signup_screen_event.dart';

part 'signin_signup_screen_state.dart';

class SigninSignupScreenBloc
    extends Bloc<SigninSignupScreenEvent, SigninSignupScreenState> {
  SigninSignupScreenRepository? repository;

  SigninSignupScreenBloc({this.repository}) : super(SignupScreenInitial()) {
    on<SigninSignupScreenEvent>(mapEventToState);
  }

  void mapEventToState(
    SigninSignupScreenEvent event,
    Emitter<SigninSignupScreenState> emit,
  ) async {
    if (event is SignUpEvent) {
      try {
        var model = await repository?.addCustomer(
            event.wkToken,
            event.customer_group_id,
            event.firstnam,
            event.lastname,
            event.email,
            event.telephone,
            event.password,
            event.isSubscribe,
            event.agree,
            event.tobecomepartner,
            event.shoppartner,
            event.android_device_id,
          event.company,
          event.address_1,
          event.address_2,
          event.city,
          event.postcode,
            event.zone_id,
          event.country_id,
          event.customFieldJson,
            event.sector

        );
        if (model != null) {
          if ((model.error ?? 0) >= 1) {
            print("object ${model.customerId}");
            if(model.customerId!=null){
              emit(SignupScreenFormSuccess(model));
            }else{
              emit(SigninSignupScreenError(model.message));
            }

          } else {
            emit(SignupScreenFormSuccess(model));
            AppSharedPref.setLogin(true);
          }
        } else {
          emit(SigninSignupScreenError(""));
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is GetRegisterDataEvent) {
      var model = await repository?.getRegisterPageData(event.wkToken);
      if (model != null) {
        if ((model.error ?? 0) >= 1) {
          SigninSignupScreenError(model.message);
        } else {
          emit(RegisterDataSuccess(model));
        }
      } else {
        emit(SigninSignupScreenError(""));
      }
    } else if (event is LoginEvent) {
      try {
        var model = await repository?.loginCustomer(
            event.wkToken, event.name, event.password, event.fcmToken);
        if (model != null) {
          if ((model.error ?? 0) >= 1) {
            emit(SigninSignupScreenError(model.message));
          } else {
            emit(LoginState(model));
            AppSharedPref.setLogin(true);
            AppSharedPref.setCustomerId(model.customerId);
          }
        } else {
          emit(SigninSignupScreenError(""));
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is ForgotPasswordEvent) {
      try {
        var model =
            await repository?.forgotPassword(event.wkToken, event.email);
        if (model != null) {
          if (model.error == 0) {
            emit(ForgotPasswordState(model));
          } else {
            emit(SigninSignupScreenError(model.message));
          }
        } else {
          emit(SigninSignupScreenError(""));
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    }

    else if (event is CheckEmailEvent) {
      // emit(LoadingState());
      try {
        var model = await repository?.checkEmail(event.wkToken, event.email);
        if (model != null) {
          if (model.error != 0) {
            emit(const CheckEmailStateError());
          } else {
            emit(const CheckEmailStateSuccess());
          }
        }
      } catch (error, _) {
        emit(SigninSignupScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    }
  }
}
