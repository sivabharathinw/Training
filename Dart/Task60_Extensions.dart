extension myextension on int{
int add(int other){//automatically current number is passed when we called the method that is represented by this
//if i want to pass another parameter represnts  in a method paramater
  return this+other;
}
int addThree(int other ,int another){
  return this+other+another;
}

}
extension boolextension on bool{
  bool calculateLogic(bool other){
    return this&&other;
  }
  
}
void main(){
  int res=5.add(10);
  print(res);
  int three=res.add(90);
  print(three);
  int third=10.addThree(90,80);
  print(third);
  print(true.calculateLogic(true));
  print(true.calculateLogic(false));
  print(false.calculateLogic(true));
  print(false.calculateLogic(false));
}