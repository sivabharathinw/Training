void main(){
  Map<String,int> marks={"English":90,"Maths":80,"science":100,"computerscience":100};
  var votersEligible={18:true,15:false,22:true};
  marks["AIML"]=90;
  votersEligible[66]=true;
  print("after adding another subject in marks :$marks");
  print("after adding another voters age in votersEligible:$votersEligible");
  //adding multiple elemnts at once 
marks.addAll({"java":100,"aiml":90});
print("after adding multiole values $marks");
//to acces the  values from map use map[key]
print("The values marks[English] is { $marks[English]}");
//to access all keys




}