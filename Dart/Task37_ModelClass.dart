import 'dart:convert';
class User{
String username;
int userid;
String pass;
User(this.userid,this.username,this.pass);
String toString(){
  return "id:${userid},name:${username}";
}
Map<String,dynamic> toJson(){
  return{
    'userid':userid,
    'username':username,
    'pass':pass
  };

}
User.fromJson(Map<String,dynamic>json)
: userid=json['userid'],
username =json['username'],
 pass=json['pass'];


}
void main(){
  User u=User( 1,"Bharathi", "Pass@123");
  User u1=User( 2,"siva", "Password@123");
   User u2=User( 1,"sb", "P123");
   print(u1);
   Map<String,dynamic> m=u.toJson();
   print(m);
String jsonString='{"id":1,"name":"bharathi","pass":"bharu@123"}';
Map<String ,dynamic> map=jsonDecode(jsonString);
print(map);




}