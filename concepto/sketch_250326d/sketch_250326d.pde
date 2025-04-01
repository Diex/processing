float hueValue = 0; // For cycling through colors in HSB mode

void setup() {
  size(640, 640); // 32 squares * 20 pixels each
  colorMode(HSB, 360, 100, 100); // Switch to HSB: Hue (0-360), Saturation, Brightness
  background(0, 0, 100); // White background in HSB (max brightness, no hue/saturation)
}

void draw() {
  background(0, 0, 100); // Clear with white each frame
  drawGrid(); // Draw the base grid
  drawFigure(); // Draw the figure with changing colors
  
  // Update hue for color animation
  hueValue = (hueValue + 1) % 360; // Cycle hue from 0 to 360
}

void drawGrid() {
  stroke(0, 0, 0); // Black lines in HSB
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
  fill(hueValue, 100, 100); // Fill with animated hue, full saturation/brightness
  noStroke(); // No outline for the figure squares
  
  // Center of the 32x32 grid is at (16, 16)
  int center = 16;
  
  // Draw the symmetrical diamond-like figure
  for (int i = 0; i < 8; i++) {
    // Vertical and horizontal symmetry
    rect((center - i) * squareSize, center * squareSize, squareSize, squareSize); // Left arm
    rect((center + i) * squareSize, center * squareSize, squareSize, squareSize); // Right arm
    rect(center * squareSize, (center - i) * squareSize, squareSize, squareSize); // Top arm
    rect(center * squareSize, (center + i) * squareSize, squareSize, squareSize); // Bottom arm
    
    // Diagonal extensions for diamond shape
    rect((center - i) * squareSize, (center - i) * squareSize, squareSize, squareSize); // Top-left
    rect((center + i) * squareSize, (center - i) * squareSize, squareSize, squareSize); // Top-right
    rect((center - i) * squareSize, (center + i) * squareSize, squareSize, squareSize); // Bottom-left
    rect((center + i) * squareSize, (center + i) * squareSize, squareSize, squareSize); // Bottom-right
  }
}
