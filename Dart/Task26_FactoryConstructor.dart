class Person {
  String name;
  //named constructor
  Person.name1(this.name);
//factory constructor
  factory Person(String name) {
    if (name.isEmpty) {
      //factory constructor alwys return instance
      return Person.name1("Guest");
    }
    return Person.name1(name);
  }
}

void main() {
  var p1 = Person("");
  var p2 = Person("Siva");

  print(p1.name); 
  print(p2.name);   }