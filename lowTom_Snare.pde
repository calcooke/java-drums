class lowTom_Snare{
  
  float drumHeight;
  float drumWidth;
  float drumXpos;
  float drumYpos = 0;
  
  void display(){
  
    rectMode(CENTER);
    stroke(255);
    fill(104, 176, 125);
    rect(drumXpos, drumYpos, drumWidth, drumHeight);

  }
  
}