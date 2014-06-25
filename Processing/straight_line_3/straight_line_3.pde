int step = 10;
float lastx = -999;
float lasty = -999;
float y = 50;
int border = 20;

for (int x=border; x<=width-border; x+=step) {
  if (lastx > -999) {
    line(x, y, lastx, lasty); 
  }
  lastx = x;
  lasty = y;
}

