class Table{
  void multiply(int num){
    for(int i=1;i<=10;i++){
      print("$num *  $i =${num*i}");
    }
  }
}
void main(){
  int num=5;
  Table t=Table();
  t.multiply(num);
}