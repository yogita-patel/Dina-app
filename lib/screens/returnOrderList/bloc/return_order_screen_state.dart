import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/returnOrderListModel/return_order_list_model.dart';

abstract class ReturnOrderScreenState extends Equatable {
  const ReturnOrderScreenState();

  @override
  List<Object> get props => [];
}

class ReturnOrderScreenInitial extends ReturnOrderScreenState{}

class ReturnOrderScreenSuccess extends ReturnOrderScreenState{
  final ReturnOrderListModel returns;
  const ReturnOrderScreenSuccess(this.returns);
}

class ReturnOrderScreenError extends ReturnOrderScreenState{
  final String message;
  const ReturnOrderScreenError(this.message);
}



