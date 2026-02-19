class Animal{
  String type="animal";
void sound(){
  print("animal sound");
}  
}
class Dog extends Animal{
  String name="dog";
  void  category(){
    print("Dog is an $type");
  }
}
class Cat extends Animal{
String name="cat";
void category(){
  print("cat is an $type");
}
}


void main(){
  Dog d=Dog();
  Cat c=Cat();
  Animal a =Dog();
  d.sound();
  d.category();
  c.sound();
  c.category();
  print(c.type);
   print(d.type);
a.sound();

}