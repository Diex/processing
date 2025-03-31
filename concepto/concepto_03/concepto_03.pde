int[][] rCore = new int[16][16]; // 16x16 core for Red
int[][] gCore = new int[16][16]; // 16x16 core for Green
int[][] bCore = new int[16][16]; // 16x16 core for Blue
int[][] grid = new int[32][32];  // 32x32 full grid (0-7)
int t = 0; // Time for bytebeat

// Constants for each color, randomized at startup
int rConst; // Red constant
int gConst; // Green constant
int bConst; // Blue constant

void setup() {
  
  size(640, 640); // 32 squares * 20 pixels
  rConst = floor(random(256)); // Randomize Red constant
  gConst = floor(random(256)); // Randomize Green constant
  bConst = floor(random(256)); // Randomize Blue constant
  frameRate(20); // Slower animation
  ellipseMode(CENTER);
  fullScreen();
}

void draw() {
  background(0); // Black background
  
  // Update cores with 3 bytebeat algorithms
  for (int y = 0; y < 16; y++) {
    int tValue = t * 16 + y * 16; // Base t for this row
    
    // Red: (t >> 7) ^ (t + rConst)
    int rValue = (tValue >> 7) ^ (tValue + rConst);
    // Green: (t * 69069) & (t >> 9) + gConst
    int gValue = (tValue * 69069) & (tValue >> 9) + gConst;
    // Blue: (t ^ (t >> 11)) + (t >> 13) + bConst
    int bValue = (tValue ^ (tValue >> 11)) + (tValue >> 13) + bConst;
    
    for (int x = 0; x < 16; x++) {
      rCore[x][y] = (rValue >> x) & 1; // Red bit
      gCore[x][y] = (gValue >> x) & 1; // Green bit
      bCore[x][y] = (bValue >> x) & 1; // Blue bit
    }
  }
  
  // Combine cores into full grid
  for (int y = 0; y < 16; y++) {
    for (int x = 0; x < 16; x++) {
      int r = rCore[x][y];
      int g = gCore[x][y];
      int b = bCore[x][y];
      int value = (r << 2) | (g << 1) | b; // 3-bit RGB (0-7)
      if (value == 7) value = 0; // Replace white (111) with black (000)
      grid[x][y] = value;           // Top-left
      grid[31 - x][y] = value;      // Top-right
      grid[x][31 - y] = value;      // Bottom-left
      grid[31 - x][31 - y] = value; // Bottom-right
    }
  }
  
  // Draw full grid
  noStroke();
  for (int y = 0; y < 32; y++) {
    for (int x = 0; x < 32; x++) {
      int value = grid[x][y];
      int r = (value & 4) == 4 ? 255 : 0; // Red bit
      int g = (value & 2) == 2 ? 255 : 0; // Green bit
      int b = (value & 1) == 1 ? 255 : 0; // Blue bit
      fill(r, g, b);
      //fill(255);
      //stroke(0);
      //strokeWeight(4);
      pushMatrix();
      //translate(10, 10);
      //ellipse(x * 20, y * 20, 10, 10); // 10px ellipses
      rect(x*20,y*20,20,20);
      popMatrix();
    }
  }
  
  t++; // Next frame
}

void keyPressed() {
  if (key == ' ') { // Spacebar pressed
    rConst = floor(random(256)); // Re-randomize Red constant
    gConst = floor(random(256)); // Re-randomize Green constant
    bConst = floor(random(256)); // Re-randomize Blue constant
    t = floor(random(1E10));
  }
  if(key == 's'){
    saveFrame("img_"+frameCount+".jpg");
  }
}
