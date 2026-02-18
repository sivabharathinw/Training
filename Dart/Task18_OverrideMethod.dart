class Polymorphism{
 
void add(int a,int b){
  print("Parent");
  print(a+b);
}
}
class childPolymorphism{
  
  void add(int x,int y ){
    print("child ");
    print(x+y);
  }
}
void main(){
   int num1=10;
  int num2=20;
  
  childPolymorphism c=childPolymorphism();
  c.add(num1,num2);
  


}