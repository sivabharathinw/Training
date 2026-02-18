class Numbers{
Future <int> getNumbers ()async{//this method getNumbers return an integer value  but it returns late so i use Future before datatypee
print("Fake api is fetching........");
await Future.delayed(Duration(seconds: 3));//make delay  in this line like rela time api fetch delay
return 10;//return the data
   
}
}
void main()async{
Numbers n=Numbers();
//print(n.getNumbers())=>this leads to instance of future error bcz the integer value returned delay so first get the number usimg await then print it
var result= await n.getNumbers();
print(result);
}