

void main(){
  List<int> l1=[1,2,3,4,5];
  List<String> l2=["one","two","three"];
  var l3=[89.9,90.5,89,6];
  var l4=[100,90,80];

  print("Initial stage of :$l1");
  print("Initial stage of :$l2");
  print("Initail stage of :$l3");
  // In addition there are many methods
  //add

  l1.add(6);
  l1.add(7);
  l1.add(8);
  l2.add("four");
  l2.add("five");
  l3.add(121.89);

   print("After adding elements in l1 :$l1");
  print("After adding elements in l2 :$l2");
  print("IAfter adding elements in l3:$l3");
  //addAll
 l1.addAll(l4);
 //insert--to add element at specific index
 l4.insert(1,95);
 l2.insert(0,"zero");
 //insertAll---insert multiple items at index
l1.insertAll(0,[-1,-2]);
//using + operator 
var mynewlist=l2+["twenty","thirty","fourty"];
print("mynewlist created using + operator $mynewlist");
//add using spread operators
var combinedList=["ones","tens","hundreds","thousands"];
var mynewList=[...l3,...[2,3,4]];
print(mynewList);
// remove--many methods
//remove--remove the particular value
var names=["harini","bharathi","siva","nativewit","lenova"];
names.remove("harini");
print("after removing harini in names :$names");
//removeAt--remove value at specific index
names.removeAt(1);
print("after removing the value  at index 1:$names");

//removeLast--Automatically remove the last element
names.removeLast();
print("After removing the last element using removeLast():$names");
//removeRange--it removes the values from range we need to give start and end
var colors=["red","blue","white","black","pink"];
colors.removeRange(1, 3);
print("After removing the values from color List from the rannge 1 to 3:$colors");
//removeWhere -this method remove the values whose satisfies the condition
var votersAge=[20,22,17,18,24,19,15,34];
votersAge.removeWhere((n)=>n<18);
print("Eligible voters age :$votersAge");










}