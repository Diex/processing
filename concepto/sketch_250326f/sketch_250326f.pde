int[][] grid = new int[32][32]; // 32x32 grid for bit states
int frame = 0; // Animation counter

void setup() {
  size(640, 640); // 32 squares * 20 pixels each
  background(255); // White background
  initializeAlien(); // Set initial alien pattern
}

void draw() {
  background(255); // Clear each frame
  drawGrid(); // Draw the base grid
  animateAlien(); // Update and draw the alien
  frame++; // Advance animation
}

void drawGrid() {
  stroke(0); // Black lines
  noFill(); // No fill for grid lines
  int squareSize = 20;
  for (int x = 0; x < 32; x++) {
    for (int y = 0; y < 32; y++) {
      rect(x * squareSize, y * squareSize, squareSize, squareSize);
    }
  }
}

void initializeAlien() {
  // Define a Space Invader-like alien centered in the 32x32 grid
  // Using 1s for filled squares, roughly 16x16 area centered at (16, 16)
  int[][] alienPattern = {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, // y=8
    {0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0}, // y=9 (antennas)
    {0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0}, // y=10
    {0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0}, // y=11 (head)
    {0,0,0,1,1,0,1,1,1,1,0,1,1,0,0,0}, // y=12 (eyes)
    {0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0}, // y=13 (body)
    {0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0}, // y=14
    {0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0}, // y=15 (mouth/tentacles)
    {0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0}, // y=16 (legs)
    {0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0}, // y=17
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}  // y=18
  };
  
  // Place the pattern in the center of the 32x32 grid
  for (int y = 0; y < 11; y++) {
    for (int x = 0; x < 16; x++) {
      grid[x + 8][y + 8] = alienPattern[y][x]; // Offset to center at (16, 16)
    }
  }
}

void animateAlien() {
  int squareSize = 20;
  noStroke();
  
  // Draw the current state of the grid
  for (int x = 0; x < 32; x++) {
    for (int y = 0; y < 32; y++) {
      if (grid[x][y] == 1) {
        fill(0, 255, 0); // Green for alien (bit = 1)
        rect(x * squareSize, y * squareSize, squareSize, squareSize);
      }
    }
  }
  
  // Animate: Toggle legs and antennas every few frames
  int step = (frame / 20) % 2; // Toggle every 20 frames, 0 or 1
  if (step == 0) {
    // Legs out, antennas up
    grid[13][16] = 1; grid[18][16] = 1; // Legs at x=13, x=18, y=16
    grid[14][17] = 0; grid[17][17] = 0; // Clear alternate leg positions
    grid[13][9] = 1;  grid[18][9] = 1;  // Antennas at x=13, x=18, y=9
  } else {
    // Legs in, antennas down
    grid[13][16] = 0; grid[18][16] = 0; // Clear initial leg positions
    grid[14][17] = 1; grid[17][17] = 1; // Legs at x=14, x=17, y=17
    grid[13][9] = 0;  grid[18][9] = 0;  // Clear antennas
  }
}
