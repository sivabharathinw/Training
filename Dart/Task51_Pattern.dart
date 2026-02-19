import "dart:io";
class Star {
void Print(int num){
  for(int i=0;i<num;i++){
    for(int j=0;j<=i;j++){
      stdout.write("*");
    }
      print(" ");
  }
}

}

void main(){
  int n=5;
  Star s=Star();
  s.Print(n);
}