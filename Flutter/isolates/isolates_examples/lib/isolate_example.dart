import 'dart:isolate';
void main(){
  //receive port to receive messages from isolate
  ReceivePort rp = ReceivePort();
  //send port to send messages to isolate
  SendPort sp = rp.sendPort;
  Isolate.spawn(greetingIsolate, sp);//after creating isolate we need to listen to receive port
  print("before listen in main thread");
  rp.listen((message) {
    print(message);
  });
  print("after listen  in main thread");

}
void greetingIsolate(SendPort sp){
  sp.send("Hello from isolate");
}