class Student<T>{
T data;
Student(this.data);
 @override
String toString(){
   return  "This is the Student information $data";
 }

}
class Balls <T>{
  T data;
  Balls(this.data);
}
void main(){
  Student <String> name=Student("Bharathi");
  Student<int> id=Student(15);
  Student<bool> maritalstatus=Student(false);
  Student<double> cgpa=Student(8.9);
  print(name);//without toString method it will print objects
  print(id);
  print(maritalstatus);
  print(cgpa);
  Balls<String> ballname=Balls("Football");
  Balls<int> cost=Balls(200);
  Balls<double> radius=Balls(8.0);
print(ballname);
print(cost);
print(radius);


  
  
}