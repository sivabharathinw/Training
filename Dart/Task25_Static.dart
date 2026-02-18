class counter{
  static int  count=0;
  static increase(){
    count++;
  }
}
void main(){
  counter c=counter();
  //static methods accesed with classname not objects
  counter.increase();
    counter.increase();
      counter.increase();
      print(counter.count);

  

}