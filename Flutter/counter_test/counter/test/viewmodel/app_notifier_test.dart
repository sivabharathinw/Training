import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery/viewmodel/app_notifier.dart';
import 'package:food_delivery/repository/app_repository.dart';

void main() {

  test('Search query should update correctly', () {

    final repo = AppRepository();
    final notifier = AppNotifier(repo);

    notifier.updateSearch("Pizza");

    expect(notifier.state.searchQuery, "pizza");

  });

}