int[][] rGrid = new int[16][16]; // 16x16 core for Red (0 or 1)
int[][] gGrid = new int[16][16]; // 16x16 core for Green (0 or 1)
int[][] bGrid = new int[16][16]; // 16x16 core for Blue (0 or 1)
int[][] fullGrid = new int[32][32]; // 32x32 full grid with combined RGB (0-7)
int frame = 0; // Animation counter (time offset)

void setup() {
  size(640, 640); // 32 squares * 20 pixels each
  background(255); // White background
  updateCore(); // Generate initial 16x16 patterns
  updateFullGrid(); // Apply symmetry to 32x32
}

void draw() {
  background(255); // Clear each frame
  drawGrid(); // Draw the base grid
  drawPattern(); // Draw the current pattern
  
  // Update every 10 frames for faster evolution
  if (frame % 1 == 0) {
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
  int t = frame; // Base time offset
  for (int y = 0; y < 16; y++) {
    for (int x = 0; x < 16; x++) {
      int tValue = t + (y * 16 + x); // Unique 't' per position
      
      // Three bytebeat formulas, one per color channel
      rGrid[x][y] = ((tValue * (tValue >> 7)) & 1);         // Red: bit 0 of t * (t >> 7)
      gGrid[x][y] = (((tValue >> 5) ^ (tValue >> 3)) & 1);  // Green: bit 0 of (t >> 5) ^ (t >> 3)
      bGrid[x][y] = ((tValue & (tValue >> 9)) & 1);         // Blue: bit 0 of t & (t >> 9)
    }
  }
}

void updateFullGrid() {
  // Combine R, G, B into a 3-bit value (0-7) and replicate symmetrically
  for (int x = 0; x < 16; x++) {
    for (int y = 0; y < 16; y++) {
      int value = (rGrid[x][y] << 2) | (gGrid[x][y] << 1) | bGrid[x][y]; // R:4, G:2, B:1
      fullGrid[x][y] = value;              // Top-left
      fullGrid[31 - x][y] = value;         // Top-right
      fullGrid[x][31 - y] = value;         // Bottom-left
      fullGrid[31 - x][31 - y] = value;    // Bottom-right
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
      int r = (value & 4) == 4 ? 255 : 0; // Bit 2 (R)
      int g = (value & 2) == 2 ? 255 : 0; // Bit 1 (G)
      int b = (value & 1) == 1 ? 255 : 0; // Bit 0 (B)
      fill(r, g, b);
      rect(x * squareSize, y * squareSize, squareSize, squareSize);
    }
  }
}
