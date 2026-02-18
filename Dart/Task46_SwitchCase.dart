class Categorize{
  
void assign(int option){
  switch(option){
    case 1:
      print("one");
      break;
    case 2:
      print("Two");
      break;
  case 3:
  print("Three");
  break;
  case 4:
  print("Four");
  break;
  case 5:
  print("Five");
  break;
  default :
  print("invalid choice ");
  }
}
}


void main(){
  Categorize c=Categorize();
int x=2;
int y=5;
int z=1;
int a=9;
  c.assign(x);
  c.assign(y);
  c.assign(z);
  c.assign(a);

}