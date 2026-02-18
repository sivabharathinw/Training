mixin flyer{
  int wings=4;
  void fly(){
    print("flying on the sky with $wings wings");
  }

}
mixin walk{
  int legs=2;
  void walking(){
    print("walking slowly with $legs legs");
  }

}
class Bird   with walk,flyer{}//do not put semicolon bcz it ends the stqatement;
class Human with walk{}
void main(){
  Bird b=Bird();
  b.fly();
  
  b.legs=4;
  b.walking();
Human h=Human();
h.walking();

}