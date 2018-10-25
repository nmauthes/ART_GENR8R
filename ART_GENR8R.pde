import java.util.Date;
import java.text.SimpleDateFormat;

PImage currentImage;
SimpleDateFormat sdf;

final int INTERVAL_IN_SECONDS = 15;
final float DEFAULT_PROBABILITY = 0.99;
final int TEXT_SIZE = 30;

// Generates random images using math functions

void setup() {
  fullScreen();
  textSize(TEXT_SIZE);
  cursor(WAIT);
  
  sdf = new SimpleDateFormat("yyyyddMM_HHmmssZ");
  
  currentImage = createImage();
  background(currentImage);
  
  noCursor();
  timerStart = millis();
}

int timerStart;
boolean loading;

void draw() {
    if(!loading) {
      loading = true;
      
      new Thread(new Runnable() {
        public void run() {
          currentImage = createImage();
        }
      }).start();
    }
    
    if((millis() - timerStart) / 1000 > INTERVAL_IN_SECONDS) {
      background(currentImage);
      saved = false;
      loading = false;
      timerStart = millis();
    }
}

// Draw the image

PImage createImage() {
  PImage newImage = new PImage(width, height);
  
  Operation redEq = buildEquation(DEFAULT_PROBABILITY);
  Operation greenEq = buildEquation(DEFAULT_PROBABILITY);
  Operation blueEq = buildEquation(DEFAULT_PROBABILITY);
  
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) {
      float mapX = map(x, 0, width, -1, 1);
      float mapY = map(y, 0, height, -1, 1);
      
      float red = 127.5 * redEq.evaluate(mapX, mapY) + 127.5;
      float green = 127.5 * greenEq.evaluate(mapX, mapY) + 127.5;
      float blue = 127.5 * blueEq.evaluate(mapX, mapY) + 127.5;
      
      color pixelColor = color(red, green, blue);
      newImage.set(x, y, pixelColor);
    }
  }
  
  return newImage;
}

boolean saved;

// Save the current image

void mouseClicked() {
  if(!saved) {
      Date date = new Date();
      String filename = sdf.format(date) + ".png";
      
      save(filename);
      saved = true;
      
      String savedText = "Saved ✓";
      text(savedText, width - textWidth(savedText), textAscent());
  }  
}

// Mathematical operations

interface Operation {
  float evaluate(float x, float y);
  String toString();
}

class X implements Operation {
  float evaluate(float x, float y) { return x; }
  String toString() { return "x"; }
}

class Y implements Operation {
  float evaluate(float x, float y) { return y; }
  String toString() { return "y"; }
}

class SinePi implements Operation {
  Operation arg;
  
  SinePi(float prob) { arg = buildEquation(prob * prob); }
  float evaluate(float x, float y) { return sin(PI * arg.evaluate(x, y)); }
  String toString() { return "sin(pi*" + arg.toString() + ")"; }
}

class CosinePi implements Operation {
  Operation arg;
  
  CosinePi(float prob) { arg = buildEquation(prob * prob); }
  float evaluate(float x, float y) { return cos(PI * arg.evaluate(x, y)); }
  String toString() { return "cos(pi*" + arg.toString() + ")"; }
}

class Multiply implements Operation {
  Operation leftArg, rightArg;
  
  Multiply(float prob) {
    leftArg = buildEquation(prob * prob);
    rightArg = buildEquation(prob * prob);
  }
  float evaluate(float x, float y) { return leftArg.evaluate(x, y) * rightArg.evaluate(x, y); }
  String toString() { return leftArg.toString() + "*" + rightArg.toString(); }
}

Operation buildEquation(float prob) {
  if(random(1) < prob) {
    int rand = int(random(3));
    
    if(rand == 0) { return new SinePi(prob); }
    else if (rand == 1) { return new CosinePi(prob); }
    else { return new Multiply(prob); }
  }
  
  else {
    int rand = int(random(2));
    
    if(rand == 0) { return new X(); }
    else { return new Y(); }
  }
}