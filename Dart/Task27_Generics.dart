class Box<T>{//here <T> means Type in dart
T data;
Box(this.data);
void display(){
  print(data);
}
}


void main(){
  //here we can create multiple data with dofferent datatypes with the help of generics
  Box<int> d=Box(8);
  Box<String> s=Box("Hi Welcome to String Datatype");
  Box<bool> b=Box(true);
  Box<double> doub=Box(65.5);
  d.display();
  s.display();
  b.display();
  doub.display();
}