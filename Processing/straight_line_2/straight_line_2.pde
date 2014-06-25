
void setup() {
  size(500,100);
  background(255);
  strokeWeight(5);
  frameRate(24);
  stroke(20,50,70);
  smooth();
}

void draw() {
  float randx = random(width);
  float randy = random(height);
  int i = 40;
  while (i > 0) {
  //for (int i=0; i < 40; i=i+1) {
    background(255);
    println(i);
    randx = random(width);
    randy = random(height);
    line(20,50,randx,randy);
    i -= 1;
  }
}

