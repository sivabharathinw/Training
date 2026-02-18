class Tasks{
int No_of_Task;
String Task_Name;
int completedTask;
int pendingTask;
bool finished;
Tasks(this.No_of_Task,this.Task_Name,this.completedTask,this.pendingTask,this.finished);
@override
String toString(){
  return "$No_of_Task $Task_Name ";
}
}


class ListingTask{
 Stream <Tasks> mylist(List<Tasks> task) async*{
  for(var t in task){
Future.delayed(Duration(seconds: 2));
yield t;
  }

 }
  
}
void main(){
  Tasks t=Tasks(10,"DartBasics",4,6,false);
  Tasks t1=Tasks(20,"DartAdvanced",8,2,false);
  Tasks t2=Tasks(5,"Project",5,5,true);
  ListingTask l=ListingTask();
   List<Tasks> list=[];
 list.add(t);
 list.add(t1);
 list.add(t2);
 print(list);
l. mylist(list).listen((value){
  print(value);
 });

  
}