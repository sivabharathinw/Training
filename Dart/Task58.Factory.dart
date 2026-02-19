class User{
  String name;
  static User? _instance;//object refernce for class User this must be static bcz if not static everytime we call the construvtpr it creates new obh rhere is no use
 //with static it can  shared among all objects 
  User._myuser(this.name);//here myuser is a named constructor
  factory User(String name){
    if(_instance==null){
      //if the object is null create new object
      _instance=User._myuser(name);
      print("you created the first obj bcz there is no obj exist");
   
   
    }
  //if the object is not nu;ll retru the exixting obj
  print("already obj exisit");

  return _instance!;//here we returned the existing instance important instance! assertoperator is used bcz it might be null but factor constructor returns non nulllable value
   

//here we did not create object we just return an existing obj if exists  
 }
}
void main(){
  User u1=User("bharathi");
  User u2=User("Siva");
  User u3=User("bharathi");
  print(u1.name);//bharathi
  print(u2.name);//bharathi
  print(u3.name);//bharathi bcz onl oe obj is created using factory constrctor
  print(u1==u2);//returns true both same object
}