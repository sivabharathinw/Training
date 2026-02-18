class Deposite implements Exception{//when create custom excepton class should implement the exception class
//method to show the error 
String toString(){
  return "your amount is invalid cannot deposite";
} 
}
class ATM{
void depamount(int amount){
  if(amount<0){
    throw new Deposite();

  }
  else{
    print("your amount deposited successfully");
  }

}
}



void main(){
  ATM d=ATM();
  try{
  d.depamount(200);
    d.depamount(-1);
  }
  catch(e){
    print("${e}");
  }

}