import 'dart:isolate';
import 'dart:convert';

void main() {
  ReceivePort receivePort = ReceivePort();
  Isolate.spawn(parseData, receivePort.sendPort);
  receivePort.listen((message) {
    print('Parsed data: $message');
  });
}
void parseData(SendPort sendPort) {
  // Simulate data fetching and parsing
  String jsonData = '{"users": [{"name": "Alice"}, {"name": "Bob"}]}';
  Map<String, dynamic> parsedData = json.decode(jsonData);
  sendPort.send(parsedData['users']);
}