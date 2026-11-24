import 'dart:async';

class SearchQueryDebouncer {
  SearchQueryDebouncer({required this.delay});

  final Duration delay;
  Timer? _timer;

  void submit(String query, void Function(String query) onSubmit) {
    _timer?.cancel();
    _timer = Timer(delay, () => onSubmit(query));
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    cancel();
  }
}
