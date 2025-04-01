float scaleFactor = 1.0; // Controls the size of the figure
float scaleSpeed = 0.02; // Speed of scaling

void setup() {
  size(640, 640); // 32 squares * 20 pixels each
  background(255); // White background
}

void draw() {
  background(255); // Clear the background each frame
  drawGrid(); // Draw the base grid
  drawFigure(); // Draw the animated figure
  
  // Update scaleFactor for pulsing effect
  scaleFactor += scaleSpeed;
  if (scaleFactor > 1.5 || scaleFactor < 0.5) {
    scaleSpeed *= -1; // Reverse direction at limits
  }
}

void drawGrid() {
  stroke(0); // Black lines
  noFill(); // No fill for grid squares
  int squareSize = 20;
  for (int x = 0; x < 32; x++) {
    for (int y = 0; y < 32; y++) {
      rect(x * squareSize, y * squareSize, squareSize, squareSize);
    }
  }
}

void drawFigure() {
  int squareSize = 20;
  fill(255, 0, 0); // Red fill for the figure
  noStroke(); // No outline for the figure squares
  
  // Center of the 32x32 grid is at (16, 16)
  int center = 16;
  
  // Draw a symmetrical diamond-like figure with scaling
  for (int i = 0; i < 8; i++) {
    // Adjust positions with scaleFactor for pulsing
    float scaledI = i * scaleFactor;
    
    // Vertical and horizontal symmetry
    rect((center - scaledI) * squareSize, center * squareSize, squareSize, squareSize); // Left arm
    rect((center + scaledI) * squareSize, center * squareSize, squareSize, squareSize); // Right arm
    rect(center * squareSize, (center - scaledI) * squareSize, squareSize, squareSize); // Top arm
    rect(center * squareSize, (center + scaledI) * squareSize, squareSize, squareSize); // Bottom arm
    
    // Diagonal extensions for diamond shape
    rect((center - scaledI) * squareSize, (center - scaledI) * squareSize, squareSize, squareSize); // Top-left
    rect((center + scaledI) * squareSize, (center - scaledI) * squareSize, squareSize, squareSize); // Top-right
    rect((center - scaledI) * squareSize, (center + scaledI) * squareSize, squareSize, squareSize); // Bottom-left
    rect((center + scaledI) * squareSize, (center + scaledI) * squareSize, squareSize, squareSize); // Bottom-right
  }
}
