class HiHat{
 
  int leftPointX;
  int leftPointY;
  
  int midPointX;
  int midPointY;
  
  int rightPointX;
  int rightPointY;
  
  float rotateAngle;
    
  void display(){
  
    stroke(255);
    fill(255,255,0); 
    rotate(rotateAngle);
    triangle(leftPointX,leftPointY, midPointX, midPointY, rightPointX, rightPointY);
  
  }
   
  
}