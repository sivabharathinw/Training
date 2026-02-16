void main(){
  List<String>names=["siva","bharathi","harini"];
  //to print
  names.forEach((name){
print(name);
  });
  //to update
  names.forEach((name)=>print(name.toUpperCase()));
}