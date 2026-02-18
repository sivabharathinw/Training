class CheckisOdorEven{
  void check(int num){
print(num%2==0?"$num is even":"$num is odd");

  }}

void main(){
  CheckisOdorEven c=CheckisOdorEven();
  c.check(10);
  c.check(6);
  c.check(-1);
  c.check(-9);
  c.check(-30);
  c.check(0);//0 is even 
  
  

}