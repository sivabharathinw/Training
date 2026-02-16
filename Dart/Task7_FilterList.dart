void main(){
  List<int> numbers=[10,25,30,45];
 var evens=[numbers.where((n)=>n%2==0)];
  print(evens);
}