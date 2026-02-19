abstract class Shape{
  //abstract method 
  double area();
}
class Square extends Shape{
  double size;
  Square(this.size);
  double area(){
    return size*size;

  }
}
class Circle extends Shape{
  double radius ;
  Circle(this .radius);
  double area(){
    return 3.14*radius*radius;
  }

  
}
class Rectangle extends Shape{
  double length,width;
  Rectangle(this.length,this.width);
  double area(){
    return length*width;
  }
}

void main(){
  //Shape type obj is created for only in the case of accesing the Shape class properties but with this we cannot acces  the child class properties and fields
  Shape c=Circle(9.0);
  Shape S=Square(6.0);
 //here we create child class object for acccessing the both parent abstract  class and child class proporties... 
  Rectangle rect=Rectangle(2,4);
  print(rect.area());
  print(rect.length);
  Shape r=Rectangle(2.0, 4.7);

print(c.area());
print(S.area());
print(r.area());

}