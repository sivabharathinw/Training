class Recursion{
  int fact(int n){
    if(n==1||n==0){
      return 1;

    }
    return n*fact(n-1);
  }
}


void main(){
  Recursion r=Recursion();
  print( r.fact(5));
    print( r.fact(6));
}