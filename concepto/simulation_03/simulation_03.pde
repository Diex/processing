int[][] rCore = new int[8][8];   // 8x8 core for Red
int[][] gCore = new int[8][8];   // 8x8 core for Green
int[][] bCore = new int[8][8];   // 8x8 core for Blue
int[][] grid = new int[16][16];  // 16x16 full grid (0-7)
int t = 0; // Time for bytebeat

// Constants for each color, randomized at startup
int rConst; // Red constant
int gConst; // Green constant
int bConst; // Blue constant

void setup() {
  size(640, 640); // 16 squares * 20 pixels
  rConst = floor(random(256)); // Randomize Red constant
  gConst = floor(random(256)); // Randomize Green constant
  bConst = floor(random(256)); // Randomize Blue constant
  frameRate(20); // Slower animation
  ellipseMode(CENTER);
}

void draw() {
  background(0); // Black background
  
  // Update 8x8 cores with 3 bytebeat algorithms
  for (int y = 0; y < 8; y++) {
    int tValue = t * 8 + y * 8; // Base t for this row
    
    // Red: (t >> 7) ^ (t + rConst)
    int t = (tValue+rConst);
    int rValue = t*(((t>>9)|(t>>13))&(25&(t>>6))); // (tValue >> 7) ^ (tValue + rConst);
    // Green: (t * 69069) & (t >> 9) + gConst
    t = (tValue+gConst);
    int gValue = (t>>7|t|t>>6)*10+4*(t&t>>13|t>>6); //(tValue * 69069) & (tValue >> 9) + gConst;
    // Blue: (t ^ (t >> 11)) + (t >> 13) + bConst
    t = (tValue+bConst);
    int bValue = t*5&(t>>7)|t*3&(t*4>>10); //(tValue ^ (tValue >> 11)) + (tValue >> 13) + bConst;
    
    for (int x = 0; x < 8; x++) {
      rCore[x][y] = (rValue >> x) & 1; // Red bit
      gCore[x][y] = (gValue >> x) & 1; // Green bit
      bCore[x][y] = (bValue >> x) & 1; // Blue bit
    }
  }
  
  // Mirror 8x8 cores into 16x16 grid
  for (int y = 0; y < 8; y++) {
    for (int x = 0; x < 8; x++) {
      int r = rCore[x][y];
      int g = gCore[x][y];
      int b = bCore[x][y];
      int value = (r << 2) | (g << 1) | b; // 3-bit RGB (0-7)
      if (value == 7) value = 0; // Replace white (111) with black (000)
      
      // Symmetry: mirror 8x8 into 16x16
      grid[x][y] = value;              // Top-left quadrant
      grid[15 - x][y] = value;         // Top-right
      grid[x][15 - y] = value;         // Bottom-left
      grid[15 - x][15 - y] = value;    // Bottom-right
    }
  }
  
  // Draw full 16x16 grid
  noStroke();
  for (int y = 0; y < 16; y++) {
    for (int x = 0; x < 16; x++) {
      int value = grid[x][y];
      int r = (value & 4) == 4 ? 255 : 0; // Red bit
      int g = (value & 2) == 2 ? 255 : 0; // Green bit
      int b = (value & 1) == 1 ? 255 : 0; // Blue bit
      fill(r, g, b);
      pushMatrix();
      translate(20, 20);
      ellipse(x * 40, y * 40, 20, 20); // 10px ellipses
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
  }
}
