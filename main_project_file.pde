import themidibus.*;
import javax.sound.midi.MidiMessage;
import processing.sound.*;
import controlP5.*;
import processing.video.*;

Capture video;
PImage controls;
ControlP5 cp5;
MidiBus myBus;
Cymbal crash;
Tom highTom, midTom, kickDrum;
lowTom_Snare lowTom, snare;
HiHat topHat, bottomHat;
float globalAmplitude;  //A mapped velocity value for movement.
float crashAmplitude;   // A velocity value for the Cymbal's rotation value.
float oscillateTime;  //Value for how long the cymbals or hi hats shake for.
int topHatYpos; // I need avariable for the Y position of the top of the hi hat for when its open.
Boolean openHihat = true;  // Ineed a boolean to say if the hi hats are open or closed.
float floorTomBounce;
float snareBounce;
float highTomScale;        //Various position and scale values mapped in relation to velocity.
float midTomScale;
float kickDrumScale;
float hihatRotation;
//int volumes;
float [] volumeSetting = new float[11];  // Creating an array to store volume settings from XML
float kickVolume = 0.5;
float snareVolume = 0.5;
float crashVolume = 0.5;
float hihatVolume = 0.5;
float openHiHatVolume = 0.5;
float highTomVolume = 0.5;
float midTomVolume = 0.5;
float floorTomVolume = 0.5;
int pitch;    //Value for keys.
//boolean note;
SoundFile[][] drumKit = new SoundFile[8][4];  // Creating a 2D array for the drum sounds

void setup(){
  
    size(1280, 720);
    
    controls = loadImage("drumMap.jpg"); //Simple image to show what keys to use
    video = new Capture (this, 320, 240, 30);
    //video.start();
    MidiBus.list();
    
    
    XML settings = loadXML("settings.xml");
    XML[] volumes = settings.getChildren("volume");  //Making an array of the "volume" nodes in the XML file
    for(int i = 0; i < volumes.length; i++){

      float f = Float.parseFloat(volumes[i].getContent());  // Parsing the volume values from XML, putting them into a temporary variable "f"
      volumeSetting[i] = f;                                 // and storing them in an array of floats
      
    }
    
    cp5 = new ControlP5(this);       //Making sliders for the volume of each component here.
    
    cp5.addSlider("kickVolume")
     .setPosition(30,560)
     .setSize(20,100)
     .setRange(volumeSetting[0], volumeSetting[10])  //I'm seting the range of allowable values to be from the first value parsed from XML to the last.
     .setNumberOfTickMarks(11)
     ;
    
    cp5.addSlider("snareVolume")
     .setPosition(100,560)
     .setSize(20,100)
     .setRange(volumeSetting[0], volumeSetting[10])
     .setNumberOfTickMarks(11)
     ;
     
    cp5.addSlider("crashVolume")
     .setPosition(170,560)
     .setSize(20,100)
     .setRange(volumeSetting[0], volumeSetting[10])
     .setNumberOfTickMarks(11)
     ;
     
    cp5.addSlider("hihatVolume")
     .setPosition(240,560)
     .setSize(20,100)
     .setRange(volumeSetting[0], volumeSetting[10])
     .setNumberOfTickMarks(11)
     ;
    
    cp5.addSlider("openHiHatVolume")
     .setPosition(310,560)
     .setSize(20,100)
     .setRange(volumeSetting[0], volumeSetting[10])
     .setNumberOfTickMarks(11)
     ;
    
    cp5.addSlider("highTomVolume")
     .setPosition(380,560)
     .setSize(20,100)
     .setRange(volumeSetting[0], volumeSetting[10])
     .setNumberOfTickMarks(11)
     ;
     
    cp5.addSlider("midTomVolume")
     .setPosition(450,560)
     .setSize(20,100)
     .setRange(volumeSetting[0], volumeSetting[10])
     .setNumberOfTickMarks(11)
     ;
     
     cp5.addSlider("floorTomVolume")
     .setPosition(520,560)
     .setSize(20,100)
     .setRange(volumeSetting[0], volumeSetting[10])
     .setNumberOfTickMarks(11)
     ;
    
  
    crash = new Cymbal();
    highTom = new Tom();
    midTom = new Tom();
    kickDrum = new Tom();
    lowTom = new lowTom_Snare();
    snare = new lowTom_Snare();
    topHat = new HiHat();
    bottomHat = new HiHat();
  
    int fileCounter = 1;  //Creating a varibale to increment the file name.
    
    for(int r = 0; r < 8; r ++){
      
      for(int c = 0; c < 4; c ++){
        
        String fileName = ("drum_" + fileCounter + ".mp3");   //Loading the drum sounds into a 2D array using their naming convention.
        drumKit[r][c] = new SoundFile(this, fileName);
        fileCounter++;
      }
      
    }

  
  myBus = new MidiBus(this, "Oxygen 25", 1);  
  
}

void captureEvent(Capture video){
  video.read();
}

void draw(){
  
    background(0, 0, 0);
   
    if(video.available()){   //If a frame is available
    video.read();            
    }
    
    image(video, 440, 130);   //placing the video behind drums.
    
    image(controls, 50, 50);  //This is a small keyboard image showing which keys can be used.
    
   
    //Here I'm building the drumkit from classes and passing values into each component  to simulate the kit being played. 
   
    crash.display();
    crash.rotateAngle = crashAmplitude * cos(TWO_PI* frameCount/oscillateTime);  //Oscillating the cymbal in relation to velocity.
   
    pushMatrix();
    translate(450, 450); 
    lowTom.display();
    lowTom.drumWidth = 120;
    lowTom.drumHeight = 150;
    lowTom.drumYpos = floorTomBounce * 10; //I'm bouncing the drum downwards in relation to velocity. Its value is mapped very small for easier control, so I multiply by 10. 
    popMatrix();
    
    pushMatrix();
    translate(710, 400);
    snare.display();
    snare.drumWidth = 120;
    snare.drumHeight = 30;
    snare.drumYpos = snareBounce * 10; //Bouncing downward
    popMatrix();
    
    pushMatrix();
    translate(700, 300);
    highTom.display();
    highTom.tomSize = 80;
    highTom.scalePercent = map(highTomScale, 0, 1, 1, 1.2); //Mapping this to keep scaling under control.
    popMatrix();
    
    pushMatrix();
    translate(550, 300);
    midTom.display();
    midTom.tomSize = 110;
    midTom.scalePercent = map(midTomScale, 0, 1, 1, 1.2); // Keeping scaling under control.
    popMatrix();
    
    pushMatrix();
    translate(600, 450);
    kickDrum.display();
    kickDrum.tomSize = 220;
    kickDrum.scalePercent = map(kickDrumScale, 0, 1, 1, 1.2); // Keeping scaling under control.
    popMatrix();
    
    pushMatrix();
    translate(800, topHatYpos);  //Inserting a variable for the Y position so i can have the hihat both open and closed.
    topHat.display();
    topHat.leftPointX = -40;
    topHat.leftPointY = 15;
    topHat.midPointX = 0;
    topHat.midPointY = 0;
    topHat.rightPointX = 40;
    topHat.rightPointY = 15;
    topHat.rotateAngle = hihatRotation * cos(TWO_PI* frameCount/oscillateTime);  //Oscillating in relation to velocity.
    popMatrix();
    
    pushMatrix();
    translate(800, 360);
    bottomHat.display();
    bottomHat.leftPointX = -40;
    bottomHat.leftPointY = -15;
    bottomHat.midPointX = 0;
    bottomHat.midPointY = 0;
    bottomHat.rightPointX = 40;
    bottomHat.rightPointY = -15;
    bottomHat.rotateAngle = hihatRotation * cos(TWO_PI* frameCount/oscillateTime);  //Oscillating in relation to velocity.
    popMatrix();
    
    if(openHihat == true){   //I'm using this boolean to open and close the hi hats by changing the top hihat's Y position.
      
        topHatYpos = 327;     
        
      } else {
        
        topHatYpos = 330;
      
    }
    
    //Here I'm fading the motion values away by multiplying themselves by 0.9. This never truly reaches 0, which could cause trouble - but it works great. This
    // brings the motion of each componement to a stop. The values of these are initially set by the velocity of the midi keys.
  
    crashAmplitude = crashAmplitude * 0.9;
    floorTomBounce = floorTomBounce * 0.9;
    snareBounce = snareBounce * 0.9;
    highTomScale = highTomScale * 0.9;
    midTomScale = midTomScale * 0.9;
    kickDrumScale = kickDrumScale * 0.9;
    hihatRotation = hihatRotation * 0.9;
  
}
  
void noteOn(int channel, int pitch, int velocity){
    
   //Here I'm setting some values for motion in relation to the velocity. I tested various combinations of values to map the amplitude and oscillation time to
   // and these turned out pretty nice. These two values are for the cymbals. For some reason oscillation proved difficult to use with the the scale functions and
   // position values on other components. An oscillating scale would have been visually nice. It should be straightforward, and I'll give it another go if time allows.
    
    globalAmplitude = map(velocity, 0, 127, 0.2, 1.5);  
    oscillateTime = map(velocity, 0, 127, 3, 10);
    
    //I'm mapping the velocity range for audio to be between 1 and 4. 
    
    int velocityRange = (int)map(velocity, 0, 127, 1, 4);
    
    //My drum sounds are recorded at different velocities physically, so here i am breaking up the midi velocity 
    // to try and emulate the real physical feeling. Hitting the key harder will play a harder hit, and 
    // playing softer will play a softer hit.
    //I'm passing the velocity range and the key pressed into another function called "drumHit" to keep everything tidier.
    
    drumHit(pitch, velocityRange, globalAmplitude);
    println(pitch);
  
}

void drumHit(int pitch, int velocityRange, float globalAmplitude){
  
  println(pitch);
  
    if (pitch == 48) {  //If this key is pressed
       
       drumKit[0][velocityRange].play();
       drumKit[0][velocityRange].amp(kickVolume);  //This is a value parsed from XML
       kickDrumScale = globalAmplitude;  //I'm setting the scale of the kick drum to a mapped velocity value. Velocity is mapped small for ease of control.
       println(pitch);
     
    }
    
    if (pitch == 50) {  //If this key is pressed
       
       drumKit[1][velocityRange].play();
       drumKit[1][velocityRange].amp(snareVolume);  //Value parsed from XML
       snareBounce = globalAmplitude;  //Changing the Y position of the snare in relation to velocity, mapped for ease of control.
       println(pitch);
    }
    
    if (pitch == 54) {  //If this key is pressed
       
        drumKit[2][velocityRange].play();
       drumKit[2][velocityRange].amp(hihatVolume);
       hihatRotation = globalAmplitude/10;  //I'm dividing the amplitude here by 10 for more control.
       openHihat = false;     // This is the closed HiHat sound, so I'm using this boolean to "close" the hi hat objects.
       
       for(int i = 0; i <= 3; i++){
         
         drumKit[3][i].stop();  //Stopping the open hi hat sound from continuing to play to when the closed hit hat is played.
         
       }
       
    }
    
    if (pitch == 56) {  //If this key is pressed
       
       drumKit[3][velocityRange].play();
       drumKit[3][velocityRange].amp(openHiHatVolume);
       hihatRotation = globalAmplitude/6; //I'm diving the amplitude of the bottom hi hat by 6, offsetting it to the top one to look more realistic.
       openHihat = true;    //signalling to move the Y position of the top hi hat to open it
  
    }
    
    if (pitch == 58) {  //If this key is pressed
    
       drumKit[4][velocityRange].play(); 
       drumKit[4][velocityRange].amp(crashVolume);
       crashAmplitude = globalAmplitude; //Setting the crash cymbal's oscillation in relation to velocity.
       
    }
    
    if (pitch == 57) {  //If this key is pressed
       
       drumKit[5][velocityRange].play();
       drumKit[5][velocityRange].amp(highTomVolume);
       highTomScale = globalAmplitude;
     
    }
    
    if (pitch == 55) {  //If this key is pressed
       
       drumKit[6][velocityRange].play();
       drumKit[6][velocityRange].amp(midTomVolume);
       midTomScale = globalAmplitude;
     
    }
    
    if (pitch == 53) {  //If this key is pressed
       
       drumKit[7][velocityRange].play();
       drumKit[7][velocityRange].amp(floorTomVolume);
       floorTomBounce = globalAmplitude;
     
    }
}


       