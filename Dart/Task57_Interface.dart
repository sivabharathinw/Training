class Bottle{//this is an example without abstrtact methods in an interface 
String status="opend";
void checkstatusofBottels(){
print("bottle is $status");
}

}
class Steelbottele implements Bottle{//implements keyword is must to implemets the interface 
@override // also override the varible in parent class  then only interface works 
String status ="closed";
  @override
  void checkstatusofBottels(){
print("Steel bottle is $status");
  }
}

class Plasticbottle implements Bottle{

  @override
  String status ="opend";
  @override
  void checkstatusofBottels(){
    print("plastic bottle is $status");

  }
}
void main(){
  //here we can create obj for this interface bcz here normal class acts as interface so for normal class interface we can create objects 
  Bottle b=Bottle();
print(b.status);//it accses ste parent values only not child class
  b.checkstatusofBottels();
  Bottle s =Steelbottele();//Steelbottele implements the bottle intrerface
  s.checkstatusofBottels();
  Bottle  p = Plasticbottle();
  p.checkstatusofBottels();

}