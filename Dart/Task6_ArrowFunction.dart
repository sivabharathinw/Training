void main(){
  Arrow a=Arrow();
  print(a.calculateMarks(70,60,90,89,79));
  print(a.modifyValue(20,30,40));
}
class Arrow{
int calculateMarks(int sub1,int sub2,int sub3,int sub4,int sub5)=>sub1+sub2+sub3+sub4+sub5;
int modifyValue(int x,int y,int z)=>(x+2)+(y+2)+(z+2);
}