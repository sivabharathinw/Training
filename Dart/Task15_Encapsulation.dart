class Encaps{
  String _name;
String _pass;
Encaps(this._name,this._pass);
String get name=>_name;
//setter cannot use like getter bcz setter need value to set so write its like a function
set pass(String pass){
  _pass=pass;

}
}


void main(){
  var e=Encaps("abc","abc@123");
  print("username:${e._name }and password is ${e._pass}");
  e.name;
  e.pass="AB@!23";

  print("username:${e._name }and password is ${e._pass}");
}