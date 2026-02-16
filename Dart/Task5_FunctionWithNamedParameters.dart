void main(){
  named n=new named();
  n.Student(age: 3);
  n.Student(name:"siva",age: 3);
  n.allStudent(name:"siva",marks:100);
  n.StudentDefault(city:"chennai",company:"nativewit");
  n.StudentDefault(company:"nativewit");
}
//note:when using namedparameter use null handling like question mark or required keyword
class named{

void Student({String? name,int? age}){
  print("name:${name} and age :$age");
}

//by default named paramters are optional so makes it required use require keywoprd
void allStudent({required String name,required int marks}){
  print("name:$name and  marks  $marks");

}

//named parameters with default values 
void StudentDefault({String? city="bangalore",String? company}){
  print("city is $city and company is $company");
}







}
