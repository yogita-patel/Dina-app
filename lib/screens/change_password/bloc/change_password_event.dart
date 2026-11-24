part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}
class AccountDetailEvent extends ChangePasswordEvent {
  final String? wkToken;

  const AccountDetailEvent(this.wkToken);
}

class ChangePassword extends ChangePasswordEvent {

  final String? old_password;
  final String? new_password;

  const ChangePassword(this.old_password,this.new_password);
}