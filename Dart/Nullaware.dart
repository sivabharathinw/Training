class Person {
  String? name;
}
void main(){
Person? p;          
print(p?.name);    // Output: null, no error

p = Person();
p.name = "Siva";
print(p.name);    // Output: Siva
}