part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}
final class ChangePasswordSuccess extends ChangePasswordState {
  final BaseModel data;
  ChangePasswordSuccess(this.data);
}
final class ChangePasswordError extends ChangePasswordState {}
final class CompleteState extends ChangePasswordState {}
