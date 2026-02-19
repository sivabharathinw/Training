class maximum{
  int max(int x,int y,int z){
    if(x>y&&x>z){
      return x;
    }
    else if(y>z){
      return y;
    }
    else{
      return z;
    }
    
  }
}


void main(){
maximum m=maximum();
print(m.max(10,30,50));
print(m.max(100,4,56));
print(m.max(1,400,56));
 print(m.max(1000,4000,5006));

}