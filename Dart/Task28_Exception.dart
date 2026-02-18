void main(){
  try{
    int a =10;
    int b=0;
    //
    //print(a/b);//it leads to nfinty bcz / is double division =>0.0 grows up=>it does not throw any exception so it does not works
    print(a~/b);//it is integer division =>3.33333=>converts into 3 

  }
  catch(e){
    print("cannot divided by zero");

  }
}