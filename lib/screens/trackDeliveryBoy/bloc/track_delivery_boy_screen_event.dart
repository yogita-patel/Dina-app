import 'package:equatable/equatable.dart';


abstract class TrackDeliveryBoyScreenEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TrackDeliveryBoyScreenDatFetchEvent extends TrackDeliveryBoyScreenEvent {
  TrackDeliveryBoyScreenDatFetchEvent(this.id);

  final String id;

  @override
  List<Object> get props => [];
}
