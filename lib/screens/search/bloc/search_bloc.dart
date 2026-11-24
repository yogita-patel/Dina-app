import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/search/bloc/search_events.dart';
import 'package:oc_demo/screens/search/bloc/search_repository.dart';
import 'package:oc_demo/screens/search/bloc/search_state.dart';

class SearchScreenBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepository? repository;
  int _latestRequestId = 0;

  SearchScreenBloc({this.repository}) : super(SearchInitialState()) {
    on<SearchSuggestionEvent>(_onSearchSuggestion);
  }

  Future<void> _onSearchSuggestion(
    SearchSuggestionEvent event,
    Emitter<SearchState> emit,
  ) async {
    final requestId = ++_latestRequestId;
    final searchKey = event.searchKey.trim();

    if (searchKey.isEmpty) {
      emit(SearchEmptyState());
      return;
    }

    emit(SearchInitialState());
    try {
      final model = await repository?.getSearchSuggestion(searchKey);
      if (requestId != _latestRequestId) return;

      if (model != null) {
        emit(SearchScreenSuccess(model));
      } else {
        emit(const SearchScreenError(''));
      }
    } catch (error, stackTrace) {
      if (requestId != _latestRequestId) return;
      print(stackTrace.toString());
      emit(SearchScreenError(error.toString()));
    }
  }
}
