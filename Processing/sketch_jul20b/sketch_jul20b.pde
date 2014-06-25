// setup and background
size(500, 300);
smooth();
background(230,230,230);
// draw two crossed lines
// stroke color
stroke(130,0,0);
strokeWeight(8);
float centX = width/2;
float centY = height/2;

line(centX - 70, centY - 70, centX + 70, centY + 70);
line(centX + 70, centY - 70, centX - 70, centY + 70);
// Change the stroke
stroke(0,125);
strokeWeight(4);
ellipse(centX - 70, centY, 50, 50);
ellipse(centX + 70, centY, 50, 50);
ellipse(centX, centY - 70, 50, 50);
ellipse(centX, centY + 70, 50, 50);

// draw a filled circle too
fill(255, 80);
ellipse(centX, centY, 75, 75);


