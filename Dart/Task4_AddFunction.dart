void main(){
  int n1=10;
  int n2=20;
  print("The sum is ${add(n1,n2)}");
  addition(20,30);
}
//method with return type;
int add(int x,int y){
  return x+y;
}
//method without return type
void addition(int x,int y){
  print(x+y);
}