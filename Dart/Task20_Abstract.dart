abstract class Vehicle{
  void stop(){
    print("Vehicle stoppped");
  }
  void start();
}
class bike extends Vehicle{
    String color;
    bike(this.color);
  void start(){
    print("bike starts");
  }
  
    void display(){
      print("color of the bike :${color}");
    }
  
}
class Car extends Vehicle{
    String brand;
    Car(this.brand);
  void start(){
    print("car starts");}
  
    void displayCar(){
      print("brand of the car :${brand}");
    }
  
}
void main(){
  Car c=Car("kia");
  bike b=bike("red");
  c.start();c.stop();
  c.displayCar();
  b.start();b.stop();b.display();}