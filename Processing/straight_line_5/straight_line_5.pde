size(500,100);
background(255);
strokeWeight(5);
stroke(20,50,70);
smooth();

int step = 10;
float xstep = 10;
float ystep = 10;
float lastx = 20;
float lasty = 50;
float y = 50;
int borderx = 20;
int bordery = 10;

for (int x=borderx; x<=width-borderx; x+=step) {
  ystep = random(20) - 10 // range -10 to 10
  y += ystep
  if (lastx > -999) {
    line(x, y, lastx, lasty); 
  }
  lastx = x;
  lasty = y;
}

