import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/view_model.dart';
import '../model/app_state.dart';

extension RefExtensions on WidgetRef {
  AppState get appState => watch(appProvider);
  AppNotifier get appNotifier => read(appProvider.notifier);
}