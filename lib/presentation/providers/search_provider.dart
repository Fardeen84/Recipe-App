import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/debounce.dart';
import 'recipe_provider.dart';

final searchQueryProvider = StateProvider<String>((_) => '');

final _debouncerProvider = Provider((_) => Debouncer(milliseconds: 500));


final searchHandlerProvider = Provider((ref) {
  final debouncer = ref.read(_debouncerProvider);
  return (String query) {
    ref.read(searchQueryProvider.notifier).state = query;
    if (query.trim().isNotEmpty) {
      debouncer.run(() => ref.read(recipeProvider.notifier).search(query));
    }
  };
});
