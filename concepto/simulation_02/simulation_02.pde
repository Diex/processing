int[][] rGrid = new int[16][16]; // 16x16 core for Red (0 or 1)
int[][] gGrid = new int[16][16]; // 16x16 core for Green (0 or 1)
int[][] bGrid = new int[16][16]; // 16x16 core for Blue (0 or 1)
int[][] fullGrid = new int[32][32]; // 32x32 full grid with combined RGB (0-7)
int frame = 0; // Animation counter (time offset)
int pauseCounter = 0; // Tracks frames during a pause
int nextPause = 60; // Frames until next pause check

// Randomness parameters (tweak these!)
float randomChance = 0.0; // Probability (0.0 to 1.0) of randomizing a bit
float randomBoost = 0.3;  // Bias toward 1s (0.0 = 50/50, positive = more 1s)

// Wave shift parameters (tweak these!)
float waveSpeed = 0.05;   // Speed of the wave shift (smaller = slower)
float waveAmplitude = 2.0; // Max shift distance in grid units

// Pause parameters (tweak these!)
int minPauseInterval = 50; // Min frames between pause checks
int maxPauseInterval = 75; // Max frames between pause checks
int minPauseDuration = 30;  // Min frames for a pause
int maxPauseDuration = 45;  // Max frames for a pause
float pauseChance = 0.3;    // Probability (0.0 to 1.0) of pausing when checked

void setup() {
  size(640, 640); // 32 squares * 20 pixels each
  background(255); // White background
  updateCore(); // Generate initial 16x16 patterns
  updateFullGrid(); // Apply symmetry to 32x32
}

void draw() {
  background(255); // Clear each frame
  drawPattern(); // Draw the current pattern
  
  // Check for pause logic
  if (pauseCounter > 0) {
    pauseCounter--; // Count down pause duration
  } else if (frame >= nextPause) {
    if (random(1) < pauseChance) {
      pauseCounter = floor(random(minPauseDuration, maxPauseDuration + 1));
    }
    nextPause = frame + floor(random(minPauseInterval, maxPauseInterval + 1));
  } else {
    // Update every 10 frames when not paused
    if (frame % 2 == 0) {
      updateCore();
      //applyWaveShift();
      updateFullGrid();
    }
    frame++;
  }
  
  drawGrid(); // Draw the base grid
  
  
}

void drawGrid() {
  stroke(0); // Black lines
  strokeWeight(4);
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
      int tX = t + x * 17; // Prime number offset for x
      int tY = t + y * 23; // Prime number offset for y
      
      // Bytebeat formulas for base bits
      int rBit = ((tX * (tY >> 6)) & 1);          // Red base
      int gBit = (((tY >> 4) ^ (tX >> 5)) & 1);   // Green base
      int bBit = ((tX + tY) & (tY >> 8) & 1);     // Blue base
      
      // Apply randomness to each bit
      if (random(1) < randomChance) {
        rBit = random(1) < 0.5 + randomBoost ? 1 : 0;
      }
      if (random(1) < randomChance) {
        gBit = random(1) < 0.5 + randomBoost ? 1 : 0;
      }
      if (random(1) < randomChance) {
        bBit = random(1) < 0.5 + randomBoost ? 1 : 0;
      }
      
      rGrid[x][y] = rBit;
      gGrid[x][y] = gBit;
      bGrid[x][y] = bBit;
    }
  }
}

void applyWaveShift() {
  int[][] tempR = new int[16][16];
  int[][] tempG = new int[16][16];
  int[][] tempB = new int[16][16];
  
  // Calculate wave offset based on frame
  float wave = sin(frame * waveSpeed) * waveAmplitude;
  
  for (int y = 0; y < 16; y++) {
    for (int x = 0; x < 16; x++) {
      int shiftX = (int)(x + wave + 16) % 16;
      int shiftY = (int)(y + wave + 16) % 16;
      
      tempR[shiftX][shiftY] = rGrid[x][y];
      tempG[shiftX][shiftY] = gGrid[x][y];
      tempB[shiftX][shiftY] = bGrid[x][y];
    }
  }
  
  arrayCopy(tempR, rGrid);
  arrayCopy(tempG, gGrid);
  arrayCopy(tempB, bGrid);
}

void updateFullGrid() {
  for (int x = 0; x < 16; x++) {
    for (int y = 0; y < 16; y++) {
      int value = (rGrid[x][y] << 2) | (gGrid[x][y] << 1) | bGrid[x][y];
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
