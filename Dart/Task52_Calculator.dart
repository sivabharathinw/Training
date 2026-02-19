class Calci{
  void add(int x,int y){
    print("${x+y}");
  }
  void sub(int x,int y){
    print("${x-y}");

  }
  void mul(int x,int y){
    print("${x*y}");
  }
  void div(int x,int y){
    if(y==0){
      print("cannot divided by zero");
      return;
    }
    print("${x~/y}");
  }
}
void  main(){
Calci c=Calci();
c.add(10,20);
c.sub(90,78);
c.mul(9,8);
c.div(8,0);
c.div(10,5);
}