class Cymbal{

  float rotateAngle;
 
  void display(){
  
  pushMatrix();
  fill(255,255,0);
  translate(350, 200);
  rotate(rotateAngle);  //Rotate by this value, set by velocity and passed in during the draw function.
  triangle(-75,25, 0, 0, 75, 25);
  popMatrix();
  
  }
   
}