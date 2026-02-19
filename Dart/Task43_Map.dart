void main(){
  Map<int,String> map={1:"bharathi",2:"siva",3:"ananya"};
  print(map);
  print("name of the user whose id  is 2 $map[2]");
  print("all the keys are ${map.keys}");
  print("all the values are ${map.values}");
  map.update(1, (value)=>"shivani");
  map.forEach((key,value)=>"$key : $value");
 
}