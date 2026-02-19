class Asynchoronous{
  //methd with Future returnType
   Future<void>api()async{//aync tells thisfunction is to handle asynchronous operation
    print("Api starts fetching");
   await Future.delayed(Duration(seconds: 4));//this line makes delay so to stp the further  code inside the block we use await keyword
    print("api completes the fetching");//after 4 seconds it print this
  }
Future<int> add(int x,int y)async{
print("start addition");
Future.delayed(Duration(seconds: 4));
return x+y;

}
}




void main()async{
 Asynchoronous a=Asynchoronous();
 await a.api();//here no need to use await keyword while calling the function bcz it does not retrun any values
 print("hello");
 print(await a.add(6,9));
  

}