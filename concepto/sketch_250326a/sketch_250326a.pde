void setup() {
  size(640, 640); // Set window size to 640x640 pixels (32 squares * 20 pixels each)
  background(255); // White background
  drawGrid(); // Call the function to draw the grid
}

void drawGrid() {
  stroke(0); // Black lines for the grid
  noFill(); // No fill for the squares, just outlines
  
  int squareSize = 20; // Size of each square in pixels
  for (int x = 0; x < 32; x++) { // Loop through 32 columns
    for (int y = 0; y < 32; y++) { // Loop through 32 rows
      rect(x * squareSize, y * squareSize, squareSize, squareSize); // Draw each square
    }
  }
}
