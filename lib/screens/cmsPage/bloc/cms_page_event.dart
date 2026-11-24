import 'package:equatable/equatable.dart';

abstract class CMSScreenEvent extends Equatable {
  const CMSScreenEvent();

  @override
  List<Object> get props => [];
}

class CMSScreenDataFetchEvent extends CMSScreenEvent {
  final String pageId;
  const CMSScreenDataFetchEvent(this.pageId);
}

class CMSScreenUrlFetchEvent extends CMSScreenEvent {
  final String url;
  const CMSScreenUrlFetchEvent(this.url);

  @override
  List<Object> get props => [url];
}
