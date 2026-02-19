mixin fly{
String speed="highspeed";
void flyer(){
  print("Flying  in a $speed");
}
}
mixin eat{
  String food="grains";
void eating(){
  print("eating $food");
}
}
mixin walk{
  String speed="slowspeed";
  void walking(){
    print("walking in a $speed");
  }


}
class Human  with eat, walk{

  String name="NormalHuman";
  int age=23;
  void display(){
print("name:$name and age is $age");
  }

}
class Bird  with fly,eat,walk{
  String color="white";
  void display(){
    print("bird color is $color");
  }

}
void main(){
  ///we cannot create objs for mixins bxz dart does not allow default constructo its purpose is to saher the behavuoir with different classes
  Human h=Human();
  h.display();
  h.eating();
  h.walking();
  Bird b=Bird();
  b.display();
  b.flyer();
  b.walking();
  b.eating();
 
}