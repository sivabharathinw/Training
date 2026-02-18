void main(){
int? age;
age = null;     
age = 20;  
String? name;
name = null;        
name = "Siva"; 
double? price = null;
bool? isLogin = true;
if (name != null) {
  print(name.length);
}
//null assertion 
String ? myname="flutter";
print(myname.length);


}