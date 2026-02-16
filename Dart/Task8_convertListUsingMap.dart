void main(){
  List<int> l1=[];
  l1.add(10);
  l1.add(30);
  l1.add(40);
  var multiple=l1.map((n)=>n*10);
  print(multiple);
}