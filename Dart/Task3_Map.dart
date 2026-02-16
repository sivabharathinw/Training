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
  print("All the keys are :${marks.keys}");
//to access all values
print("All the values are :${marks.values}");
//Loop to read all values
marks.forEach((key, value) => print("$key:$value"));
//to update values
marks.update("computerscience",(value)=>80);
print("After update the marks of computer science :$marks");
//update multiple values 
marks.forEach((key,value){
  marks[key]=value+5;

});
print("after updating multiple values by adding of 5$marks");
//update based on condition
marks.update("English",(value)=>0);
print("After update the marks of English :$marks");


marks.updateAll((key,value){
if(value==0){
  return value+25;
}
return value;
});
print("after done condition based update the english marks will be :$marks");



}




}
