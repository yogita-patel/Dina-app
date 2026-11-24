import 'package:flutter_bloc/flutter_bloc.dart';

import 'cms_page_event.dart';
import 'cms_screen_repository.dart';
import 'cms_screen_state.dart';

class CMSScreenBloc extends Bloc<CMSScreenEvent, CMSScreenState> {
  CMSScreenRepositoryImp? repository;

  CMSScreenBloc({this.repository}) : super(CMSScreenInitial()) {
    on<CMSScreenEvent>(mapEventToState);
  }

  Future<void> mapEventToState(
      CMSScreenEvent event, Emitter<CMSScreenState> emit) async {
    emit(CMSScreenInitial());
    if (event is CMSScreenDataFetchEvent || event is CMSScreenUrlFetchEvent) {
      try {
        final pageId = event is CMSScreenUrlFetchEvent
            ? await repository?.resolvePageId(event.url)
            : (event as CMSScreenDataFetchEvent).pageId;
        var model = await repository?.getMorePageData(pageId);
        if (model != null) {
          emit(CMSScreenSuccess(model));
        } else {
          emit(CMSScreenError(''));
        }
      } catch (error, _) {
        emit(CMSScreenError(error.toString()));
      }
    }
  }
}
