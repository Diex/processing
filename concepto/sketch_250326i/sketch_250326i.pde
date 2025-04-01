int[][] coreGrid = new int[16][16]; // 16x16 core data (0-7 for 3-bit RGB)
int[][] fullGrid = new int[32][32]; // 32x32 full grid with symmetry
int frame = 0; // Animation counter (acts as time 't' offset)

void setup() {
  size(640, 640); // 32 squares * 20 pixels each
  background(255); // White background
  updateCore(); // Generate initial 16x16 pattern
  updateFullGrid(); // Apply symmetry to 32x32
}

void draw() {
  background(255); // Clear each frame
  drawGrid(); // Draw the base grid
  drawPattern(); // Draw the current pattern
  
  // Update every 20 frames
  if (frame % 2 == 0) {
    updateCore();
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

void updateCore() {
  // Use a bytebeat formula to generate 0-7 values across the 16x16 grid
  int t = frame; // Use frame as the base time offset
  for (int y = 0; y < 16; y++) {
    for (int x = 0; x < 16; x++) {
      int tValue = t + (y * 16 + x); // Unique 't' for each position
      coreGrid[x][y] = (tValue * (tValue >> 8)) & 7; // Bytebeat: 3-bit value (0-7)
    }
  }
}

void updateFullGrid() {
  // Replicate 16x16 core into 32x32 with symmetry
  for (int x = 0; x < 16; x++) {
    for (int y = 0; y < 16; y++) {
      int value = coreGrid[x][y];
      fullGrid[x][y] = value;              // Top-left
      fullGrid[31 - x][y] = value;         // Top-right (horizontal mirror)
      fullGrid[x][31 - y] = value;         // Bottom-left (vertical mirror)
      fullGrid[31 - x][31 - y] = value;    // Bottom-right (both mirrors)
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
        case 0: fill(0, 0, 0); break;       // Black
        case 1: fill(0, 0, 255); break;     // Blue
        case 2: fill(0, 255, 0); break;     // Green
        case 3: fill(0, 255, 255); break;   // Cyan
        case 4: fill(255, 0, 0); break;     // Red
        case 5: fill(255, 0, 255); break;   // Magenta
        case 6: fill(255, 255, 0); break;   // Yellow
        case 7: fill(255, 255, 255); break;  // White
      }
      rect(x * squareSize, y * squareSize, squareSize, squareSize);
    }
  }
}
