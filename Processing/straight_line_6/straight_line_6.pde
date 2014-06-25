size(500,100);
background(255);
strokeWeight(5);
smooth();

stroke(0,30);
line(20,50,480,50);

stroke(20,50,70);
int step = 10;
float lastx = -999;
float lasty = -999;
float ynoise = random(10);
float noisy = 0;
float y;
int borderx = 20;

for (int x=borderx; x<=width-borderx; x+=step) {
  noisy = noise(ynoise);
  println(noisy);
  y = 10 + noisy * 80;
  if (lastx > -999) {
    line(x, y, lastx, lasty); 
  }
  lastx = x;
  lasty = y;
  ynoise += 0.03;
}

