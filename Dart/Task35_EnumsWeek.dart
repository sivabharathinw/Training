enum  weekdays{
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday;
}
void main(){
  weekdays day=weekdays.friday;
  switch(day){
    case weekdays.sunday:
      print("sunday");
      break;
    case weekdays.monday:
      print("monday");
      break;
    case weekdays.tuesday:
      print("tuesday");
      break;
    case weekdays.wednesday:
      print("wednesday");
      break;
     case weekdays.thursday:
      print("Thursday");
      break;
     case weekdays.friday:
      print("friday");
      break;
     case weekdays.saturday:
      print("saturday");
      break;
      default:
      print("invalid day ");    
    
    
    


  }
}