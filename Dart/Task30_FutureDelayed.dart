class CalculateMarks{
var x,y,z;
  CalculateMarks(this.x,this.y,this.z);
  void displayMarks(){
    print("being calculated");
    Future.delayed(Duration(seconds: 4),(){
      var total=x+y+z;
      print("Total marks ${total}");
    });
  }
}

void main(){
  CalculateMarks c=CalculateMarks(75.5,80,98.6);
c.displayMarks();
  print("Starting the program");
  Future.delayed(Duration(seconds:2),(){
    print("waiting of the program due to future delayed");
  });
  print("Stopedd the program");

}