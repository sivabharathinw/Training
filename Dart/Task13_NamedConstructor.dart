void main(){
Student s1=Student("Siva",20);
Student s2=Student.guest();
Student s3=Student.cheif();
print("${s1.name},${s1.age}");
print("${s2.name},${s2.age}");
print("${s3.name},${s3.age}");

}
 class Student{
  String name;
  int age;
  //normal constructor -->to assighn the vallues
  Student(this.name,this.age);
//named constructor for we need to create multiple constructores bcz dart does not allows method overloading
Student.guest():name="bharu",age=0;
//another named constructor
Student.cheif():name="kani",age=33;
}