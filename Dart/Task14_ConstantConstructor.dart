void main(){
var c=Constant(10,30 );
print("${c.x} and ${c.y}");
}
class Constant{
  final int x;
final int y;
const Constant(this.x,this.y);
}