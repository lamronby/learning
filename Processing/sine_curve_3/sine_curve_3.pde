float customRandom(float seed) {
  float rad = radians(seed);
  float retValue = pow(sin(rad), 3) * noise(rad*10);

  // 1 - pow(random(1), 5);
  return retValue;
}


void setup() {
  float xstep = 1;
  float lastx = -999;
  float lasty = -999;
  float angle = 0;
  float y = 50;
  size(500,100);
  background(255);
  strokeWeight(5);
  smooth();
  
  stroke(0,30);
  line(20,50,480,50);
  
  stroke(20,50,70);
  
  for (int x=20; x<=480; x+=xstep) {
    float rad = radians(angle);  
    float rndm = customRandom(angle) * 30;
    println(rndm);
    // sine cubed
    // y = 50 + (pow(sin(rad), 3) * 30);
    // sine cubed + noise
    y = 50 + rndm;  
    if (lastx > -999) {
      line(x,y,lastx,lasty);
    }
    lastx = x;
    lasty = y;
    angle++;
  }
}

