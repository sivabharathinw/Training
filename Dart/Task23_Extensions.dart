extension myStringExtension on String{
  //method to capitalize the string
  String capitalize(){
    if(this.isEmpty)return this;
    return this[0].toUpperCase()+this.substring(1);

      }
  void printwithStars(){
    print("***${this}****");

  }
  //extension getter method
  int get count=>this.length;
}
void main(){
  
  String text="welcome to dart";
  String statement="aynchoronous operation";
  //call the capitalize method
  print(" capitalized word ${statement.capitalize()}");
  //here we create our custom method with inbuilt datatype
  text.printwithStars();
  //acces the getter method from extension
  print(text.count);
}