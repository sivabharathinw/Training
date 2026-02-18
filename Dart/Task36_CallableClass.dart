class myCallable{
  void call(){
    print("object behaves like method bcz this class have the method call()");
  }
}
class CallablewithArguments{
String call(String text){
return "hello ${text}";
}
}

void main(){
  myCallable c=myCallable();
  c();//obj c is call like method
  CallablewithArguments a=CallablewithArguments();
print(a("Bharathi"));
}