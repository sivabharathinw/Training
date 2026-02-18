enum Traffic{
  green,red,yellow;
}
void main(){
  
  Traffic color=Traffic.green;
  if(color==Traffic.green){
  print("Go");

  }
  else if(color==Traffic.red){
    print("Stopp");
  }
  else{
    print("wait");
  }
}