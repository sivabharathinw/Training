class factorial{
  

  void fact(int n){
     int factvalue=1;
    for(int i=1;i<=n;i++){
      factvalue*=i;
    }
    print("factorial of $n: $factvalue");
   
    
  }
}
  void main(){
    factorial f=factorial();
    f.fact(5);
      f.fact(0);
        f.fact(6);
  }
