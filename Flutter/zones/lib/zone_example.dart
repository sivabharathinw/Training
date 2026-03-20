import 'dart:async';

void main() {
  runZonedGuarded(() {
    print("Start");

    throw Exception("Sync error!");

  }, (error, stack) {
    print("Caught: $error");

  });
}