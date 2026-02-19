abstract class Printer{//Dart does not have interface separrtly in dart every class can acts as interface when all the child class implemnets the  both methods  such as abstract and concrete 
// here we create abstract  class bcz interface  also have abstract methods ,
// we  can write abstract mrethods only inside the abstract class so we declare this class as abstract
  //these all methods are must be implemented  whether s abstract methods or nomal methods 
  void printDocument(String content);
  void display(){
    print("hello from interface");
  }
}
class HPPrinter implements Printer {
@override
  void printDocument(String content) {
    print("HP Printer printing: $content");
  }

  void scan() {
    print("HP Printer scanning a document");
  }
  @override
  void display(){
    print("hello from hp Printer");
  }
}

class CanonPrinter implements Printer {
 
  void printDocument(String content) {
    print("Canon Printer printing: $content");
  }

  void copy() {
    print("Canon Printer copying a document");
  }
    @override
  void display(){
    print("hello from canonprinter");
  }
}


void main(){
  //for interface we cannot create objects so left side unterface and right side implementation of the inteface
  Printer p=HPPrinter();
  Printer q=CanonPrinter();
  p.printDocument("dart");
  q.printDocument("Flutter");
  p.display();
  q.display();
}
