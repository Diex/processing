int[][] coreGrid = new int[16][16]; // 16x16 core data
int[][] fullGrid = new int[32][32]; // 32x32 full grid with symmetry
int frame = 0; // Animation counter

void setup() {
  size(640, 640); // 32 squares * 20 pixels each
  background(255); // White background
  randomizeCore(); // Randomize initial 16x16 pattern
  updateFullGrid(); // Apply symmetry to 32x32
}

void draw() {
  background(255); // Clear each frame
  drawGrid(); // Draw the base grid
  drawPattern(); // Draw the current pattern
  
  // Randomize every few frames
  if (frame % 20 == 0) { // Update every 20 frames
    randomizeCore();
    updateFullGrid();
  }
  frame++;
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

void randomizeCore() {
  // Randomly set 1s and 0s in the 16x16 core grid
  for (int x = 0; x < 16; x++) {
    for (int y = 0; y < 16; y++) {
      coreGrid[x][y] = random(1) < 0.3 ? 1 : 0; // 30% chance of being 1
    }
  }
}

void updateFullGrid() {
  // Replicate 16x16 core into 32x32 with symmetry
  for (int x = 0; x < 16; x++) {
    for (int y = 0; y < 16; y++) {
      int value = coreGrid[x][y];
      // Top-left quadrant
      fullGrid[x][y] = value;
      // Top-right (mirror horizontally)
      fullGrid[31 - x][y] = value;
      // Bottom-left (mirror vertically)
      fullGrid[x][31 - y] = value;
      // Bottom-right (mirror both)
      fullGrid[31 - x][31 - y] = value;
    }
  }
}

void drawPattern() {
  int squareSize = 20;
  noStroke();
  
  // Draw the full 32x32 grid based on bit states
  for (int x = 0; x < 32; x++) {
    for (int y = 0; y < 32; y++) {
      if (fullGrid[x][y] == 1) {
        fill(0, 255, 0); // Green for bit = 1
        rect(x * squareSize, y * squareSize, squareSize, squareSize);
      }
    }
  }
}
