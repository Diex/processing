int[][] coreGrid = new int[16][16]; // 16x16 core data (0-7 for 3-bit RGB)
int[][] fullGrid = new int[32][32]; // 32x32 full grid with symmetry
int frame = 0; // Animation counter

void setup() {
  size(640, 640); // 32 squares * 20 pixels each
  background(255); // White background
  randomizeCore(); // Randomize initial 16x16 pattern
  updateFullGrid(); // Apply symmetry to 32x32
  frameRate(30);
}

void draw() {
  background(255); // Clear each frame
  drawGrid(); // Draw the base grid
  drawPattern(); // Draw the current pattern
  
  // Randomize every few frames
  if (frame % 2 == 0) { // Update every 20 frames
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
  // Randomly set 0-7 in the 16x16 core grid (3-bit RGB values)
  for (int x = 0; x < 16; x++) {
    for (int y = 0; y < 16; y++) {
      coreGrid[x][y] = floor(random(8)); // 0 to 7 (8 colors)
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
  
  // Draw the full 32x32 grid with 3-bit RGB colors
  for (int x = 0; x < 32; x++) {
    for (int y = 0; y < 32; y++) {
      int value = fullGrid[x][y];
      switch (value) {
        case 0: fill(0, 0, 0); break;      // Black
        case 1: fill(0, 0, 255); break;    // Blue
        case 2: fill(0, 255, 0); break;    // Green
        case 3: fill(0, 255, 255); break;  // Cyan
        case 4: fill(255, 0, 0); break;    // Red
        case 5: fill(255, 0, 255); break;  // Magenta
        case 6: fill(255, 255, 0); break;  // Yellow
        case 7: fill(255, 255, 255); break; // White
      }
      rect(x * squareSize, y * squareSize, squareSize, squareSize);
    }
  }
}
