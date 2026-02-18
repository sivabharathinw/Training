class Manager{
String? ManagerName;
double Manager_salary;
Manager(this.ManagerName,this.Manager_salary);
void displayManager(){
  print("name:${ManagerName} and ManagerSalary :${Manager_salary}");
}
}
class Employee extends Manager{
String? EmployeeName;
double? EmployeeSalary;
Employee(this.EmployeeName,this.EmployeeSalary,String ManagerName,double Manager_salary):super(ManagerName,Manager_salary);
void displayEmp(){
print("name:${EmployeeName} and the Employeesalary is ${EmployeeSalary}");
}

}
class Person extends Employee{
String PersonName1;
double PersonSalary1;
Person(this.PersonName1,this.PersonSalary1,String EmployeeName,double EmployeeSalary,String ManagerName,double Manager_salary): super(EmployeeName, EmployeeSalary,ManagerName,Manager_salary);
void display(){
print("name:${PersonName1} and the personsalary is ${PersonSalary1}");
}
}

void main(){
  Person p=Person("FirstPerson", 25000.00,"Employee1",90.00,"Manager1",89000.00);
  p.display();
  p.displayEmp();
  p.displayManager();
  
}

