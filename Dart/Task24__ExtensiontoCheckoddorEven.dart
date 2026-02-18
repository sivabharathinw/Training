extension myIntExtions on int{
  void checkoddOrEven(){
    if(this%2==0) print("$this is Even");
    else print("$this is odd");
  }
}
void main(){
  int n=10;
  int x=5;
  int y=19;
  y.checkoddOrEven();
  x.checkoddOrEven();
  
  n.checkoddOrEven();
}