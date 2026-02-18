import 'dart:math';

class Shape{
void area(){
print("area of the shapes");
}
}
class Triangle extends Shape{
double height,breadth;
Triangle(this.height,this.breadth);
void area(){
  double area=height*breadth*1/2;
  print("Area of the traiangle ${area}");
}

}
class Square extends Shape{
  double size;
  Square(this.size);
  void area(){
    print("Area of the square is ${size*size}");
  }

}
class Circle extends Shape{
  double radius;
  Circle(this.radius);
  void area(){
print("Area of the circle is ${22/7*radius*radius}");
  }

}
void main(){
  Triangle t=Triangle(20.2, 10.5);
  t.area();
  Circle c=Circle(9.7);
  c.area();
  Square s=Square(8.1);
  s.area();
}