class Tom{
  
  float tomSize;
  float circleDiameter;
  float scalePercent;
 
  void display(){
  
    ellipseMode(CENTER);
    stroke(255);
    fill(104, 176, 125);
    scale(scalePercent, scalePercent );
    ellipse(0, 0, tomSize, tomSize);
  
  }
  
}