class GridCanvas {
  private int[][] grid;
  private int gSize = 32;
  float posX;
  float posY;
  int w;
  int h;

  // make file
  GridCanvas(final float posX, final float posY, final int w, final int h) {
    this.w = w;
    this.h = h;
    this.posX = posX;
    this.posY = posY;
    if (w < 0 || h < 0) {
      this.w = 0;
      this.h = 0;
    }
    grid = new int[h][w];
    for (int i=0; i<w; i++ ) {
      for (int j=0; j<h; j++) {
        grid[j][i] = 0;
      }
    }
  }

  // load file
  GridCanvas(final float posX, final float posY, final String[] in) {
    this.posX = posX;
    this.posY = posY;

    this.h = in.length;
    for (int i=0; i<in.length; i++) {
      String[] tmp = in[i].split(",", 0);
      if (this.w < tmp.length) {
        this.w = tmp.length;
      }
    }

    grid = new int[h][w];
    for (int j=0; j<this.h; j++) {
      in[j] = in[j].replaceAll("\\s++", "");
      String[] tmp = in[j].split(",", 0);
      for (int i=0; i<this.w; i++) {
        try {
          grid[j][i] = Integer.parseInt(tmp[i]);
        }
        catch(ArrayIndexOutOfBoundsException e) {
          grid[j][i] = 0;
        }
        catch(NumberFormatException e) {
          grid[j][i] = 0;
        }
      }
    }
    if (grid.length==0) {
      grid = new int[h][w];
      this.posX = posX;
      this.posY = posY;
    }
  }

  void setGrid(final float x, final float y, final int draw) {
    if ((x<0||y<0) || (x>=w*gSize||y>=h*gSize))return;
    grid[(int)y/gSize][(int)x/gSize] = draw;
  }

  int getGrid(final float x, final float y) {
    if ((x<0||y<0) || (x>=w*gSize||y>=h*gSize))return -1;
    return grid[(int)y/gSize][(int)x/gSize];
  }

  void setGridSize(int newGSize) {
    if (4 <= newGSize && newGSize <= 64) {
      gSize = newGSize;
    }
  }

  int getGridSize() {
    return gSize;
  }

  void draw() {
    if(gSize < 32)stroke(255 - 255 * gSize/32);
    textSize(gSize/2);
    colorMode(HSB);
    for (int j=0; j<h; j++) {
      for (int i=0; i<w; i++ ) {
        if ((0 < posX+i*gSize+gSize && 0 < posY+j*gSize+gSize) && (posX+i*gSize<width && posY+j*gSize<height)) {
          fill(color(255-(grid[j][i]*31+128)%256, 155, 255));
          rect(posX+i*gSize, posY+j*gSize, gSize, gSize);
          fill(0);
          text(grid[j][i], posX+i*gSize+gSize/2, posY+j*gSize+gSize/2);
        }
      }
    }
    stroke(0);
    textSize(16);
    colorMode(RGB);
  }
}