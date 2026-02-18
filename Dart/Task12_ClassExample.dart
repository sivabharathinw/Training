class Student{
  String name;
  int age;
  String department;
  int year;
  Student(this.name,this.age,this.department,this.year);
  void display(){ 
    print("Name:${name} ,age is $age,Department is $department and the year is $year");
  }
}

void main(){
  Student s=Student("aa",45,"ererv",2323);
  // s.age=22;
  // s.department="CSE";
  // s.year=4;
  s.display();
  College c=College("ABC", "chennau", 10);
  print("The College detail");
  print("name:${c.College_name },Address:${c.Address} and count of goldmedalist:${c.goldmedalist}");
  

}
//Normal constructor
class College{
  late String Principle;
  late String College_name;
  late String Address;
  late int goldmedalist;
  College(String College_name,String Address,int goldmedalist){
    this.College_name=College_name;
    this.Address=Address;
    this.goldmedalist=goldmedalist;
  }
  

}