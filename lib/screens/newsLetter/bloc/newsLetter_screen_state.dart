
import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/base_model.dart';


abstract class NewsLetterScreenState extends Equatable {
  const NewsLetterScreenState();

  @override
  List<Object> get props => [];
}

class NewsLetterScreenInitial extends NewsLetterScreenState {}

class NewsLetterScreenSuccess extends NewsLetterScreenState {
  NewsLetterScreenSuccess(this.baseModel);

  BaseModel baseModel;

  @override
  List<Object> get props => [];
}

class GetNewsLetterSuccess extends NewsLetterScreenState {
  GetNewsLetterSuccess(this.baseModel);

  BaseModel baseModel;

  @override
  List<Object> get props => [];
}

class NewsLetterScreenError extends NewsLetterScreenState {
  NewsLetterScreenError(this._message);

  String? _message;
  String? get message => _message;

  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}
