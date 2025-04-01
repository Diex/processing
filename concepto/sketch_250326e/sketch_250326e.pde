int[][] grid = new int[32][32]; // 32x32 grid to store bit states (0 or 1)
int frame = 0; // To control animation sequence

void setup() {
  size(640, 640); // 32 squares * 20 pixels each
  background(255); // White background
  initializeFigure(); // Set initial figure pattern
}

void draw() {
  background(255); // Clear each frame
  drawGrid(); // Draw the base grid
  animateFigure(); // Update and draw the figure
  frame++; // Advance animation step
  
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

void initializeFigure() {
  // Center of the 32x32 grid is at (16, 16)
  int center = 16;
  
  // Set initial diamond-like figure with 1s
  for (int i = 0; i < 8; i++) {
    grid[center - i][center] = 1; // Left arm
    grid[center + i][center] = 1; // Right arm
    grid[center][center - i] = 1; // Top arm
    grid[center][center + i] = 1; // Bottom arm
    
    grid[center - i][center - i] = 1; // Top-left
    grid[center + i][center - i] = 1; // Top-right
    grid[center - i][center + i] = 1; // Bottom-left
    grid[center + i][center + i] = 1; // Bottom-right
  }
}

void animateFigure() {
  int squareSize = 20;
  noStroke();
  
  // Draw the current state of the grid
  for (int x = 0; x < 32; x++) {
    for (int y = 0; y < 32; y++) {
      if (grid[x][y] == 1) {
        fill(255, 0, 0); // Red for bit = 1
        rect(x * squareSize, y * squareSize, squareSize, squareSize);
      }
    }
  }
  
  // Update the grid for the next frame (shift pattern)
  int[][] newGrid = new int[32][32];
  for (int i = 0; i < 8; i++) {
    int shift = (frame / 10) % 8; // Slow down animation, cycle every 8 steps
    int newI = (i + shift) % 8; // Shift the pattern
    
    int center = 16;
    newGrid[center - newI][center] = 1; // Left arm
    newGrid[center + newI][center] = 1; // Right arm
    newGrid[center][center - newI] = 1; // Top arm
    newGrid[center][center + newI] = 1; // Bottom arm
    
    newGrid[center - newI][center - newI] = 1; // Top-left
    newGrid[center + newI][center - newI] = 1; // Top-right
    newGrid[center - newI][center + newI] = 1; // Bottom-left
    newGrid[center + newI][center + newI] = 1; // Bottom-right
  }
  arrayCopy(newGrid, grid); // Update grid with new state
}
