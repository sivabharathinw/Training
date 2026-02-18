class CalculateTime{
  int distance;
  int speed;
  CalculateTime(this.distance,this.speed);
  void time(){
    int time=distance~/speed;
  print("The time is :$time");
  }
}
void main(){
  
  CalculateTime c=CalculateTime(100, 50);
  c.time();
}