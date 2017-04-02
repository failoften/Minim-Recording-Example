/**
 * Horn Recorder
 * by David Steele Overholt.
 * 03/12/2012
 *  
 * Information taken from RecordLineIn and 
 * Band Pass Filter Examples for Minim
 */

import ddf.minim.*;
import ddf.minim.effects.*;

Minim minim;
AudioInput in;
AudioRecorder recorder;
BandPass bpf;
AudioPlayer[] groove = new AudioPlayer[10];

int recordNum = 0;
int passBand = 90;
int bandWidth = 50;
int gain = 50;

void setup()
{
  size(512, 200, P2D);
  //textMode(SCREEN); 
  
  // create a recorder that  will record from the input to the filename specified, using buffered recording
  // buffered recording means that all captured audio will be written into a sample buffer
  // then when save() is called, the contents of the buffer will actually be written to a file
  // the file will be located in the sketch's root folder.

  
  minim = new Minim(this);
  
  // get a stereo line-in: sample buffer length of 2048
  // default sample rate is 44100, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 2048);
  
  textFont(createFont("SanSerif", 12));
  
    horn();
  
    recorder = minim.createRecorder(in,"myrecording.wav", true);
  
}

void draw()
{
  background(0); 

  /*
  stroke(255);
  
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }
  */
  
  
  if ( recorder.isRecording() )
  {
    text("Currently recording...", 5, 15);
  }
  else
  {
    text("Not recording.", 5, 15);
  }

}


 void keyReleased()
{
  if ( key == 'r' ) 
  {
    // to indicate that you want to start or stop capturing audio data, you must call
    // beginRecord() and endRecord() on the AudioRecorder object. You can start and stop
    // as many times as you like, the audio data will be appended to the end of the buffer 
    // (in the case of buffered recording) or to the end of the file (in the case of streamed recording). 
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
      recorder.save();
      
      println("Done recording #" + recordNum + " and saved.");
      
      if(recordNum < 9){
      recordNum++;
  
      }
      else {
        recordNum = 0;
      }
      
      
      horn();
    }
    else 
    {
     for(int i = 0; i < 9; i++) {
       groove[i].setGain(-5);
     } 
     
      recorder = minim.createRecorder(in,"myrecording"+recordNum+".wav", true);
      recorder.beginRecord();
      
      println("Recording #" + recordNum);
    }
  }
  if ( key == 'h' ) 
  {
   horn(); 
  }
}

void horn() {
  /*
  groove[0] = minim.loadFile("myrecording0.wav");
  groove[1] = minim.loadFile("myrecording1.wav");
  groove[2] = minim.loadFile("myrecording2.wav");
  groove[3] = minim.loadFile("myrecording3.wav");
  groove[4] = minim.loadFile("myrecording4.wav");
  groove[5] = minim.loadFile("myrecording5.wav");
  groove[6] = minim.loadFile("myrecording6.wav");
  groove[7] = minim.loadFile("myrecording7.wav");
  groove[8] = minim.loadFile("myrecording8.wav");
  groove[9] = minim.loadFile("myrecording9.wav");
  */
  
int passBand = 50; 
int bandWidth = 60; 
int gain = 30;
  // make a band pass filter with a center frequency of 440 Hz and a bandwidth of 20 Hz
  // the third argument is the sample rate of the audio that will be filtered
  // it is required to correctly compute values used by the filter
    for(int i = 0; i < 9 ; i++) {
      
      groove[i] = minim.loadFile("myrecording"+i+".wav");
      bpf = new BandPass(passBand, bandWidth, groove[i].sampleRate());
      groove[i].addEffect(bpf);    
      //bandWidth = bandWidth + 13; // 50 get to 450
      passBand = passBand + 166; // 100 get to 2000
      groove[i].setGain(gain);
      gain = gain - 4; 
      println("gain = " + gain);
      println("passBand = " + passBand);
      println("bandWidth = " + bandWidth);
    }
    
   for(int i=0; i < 9; i++) {
    groove[i].play();
   }
   
   
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
     for(int i = 0; i < 9; i++) {
       groove[i].close();
     } 
   
   minim.stop();
  
  super.stop();
}