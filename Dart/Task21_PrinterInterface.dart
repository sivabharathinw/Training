abstract class Printer{
  void printDocument(String content);
}
class HPPrinter implements Printer {

  void printDocument(String content) {
    print("HP Printer printing: $content");
  }

  void scan() {
    print("HP Printer scanning a document");
  }
}

class CanonPrinter implements Printer {
 
  void printDocument(String content) {
    print("Canon Printer printing: $content");
  }

  void copy() {
    print("Canon Printer copying a document");
  }
}
void main(){
  //for interface we cannot create objects so left side unterface and right side implementation of the inteface
  Printer p=HPPrinter();
  Printer q=CanonPrinter();
  p.printDocument("dart");
  q.printDocument("Flutter");
}
