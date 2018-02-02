class GridCanvas {
  private int[][] grid;
  float posX;
  float posY;
  int w;
  int h;

  // make file
  GridCanvas(float posX, float posY, int w, int h) {
    if (w < 0 || h < 0) {
      w = 0;
      h = 0;
    }
    grid = new int[h][w];
    for (int i=0; i<w; i++ ) {
      for (int j=0; j<h; j++) {
        grid[j][i] = 0;
      }
    }
    this.w = w;
    this.h = h;
    this.posX = posX;
    this.posY = posY;
  }

  // load file
  GridCanvas(float posX, float posY, String[] in) {
    this.posX = posX;
    this.posY = posY;

    this.h = in.length;
    for (int i=0; i<in.length; i++) {
      String[] tmp = in[i].split("\\s+", 0);
      if (this.w < tmp.length) {
        this.w = tmp.length;
      }
    }

    grid = new int[h][w];
    for (int j=0; j<this.h; j++) {
      String[] tmp = in[j].split("\\s+", 0);
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

  void setGrid(float x, float y, int draw) {
    if ((x<0||y<0) || (x>=w*32||y>=h*32))return;
    grid[(int)y/32][(int)x/32] = draw;
  }

  int getGrid(float x, float y) {
    if ((x<0||y<0) || (x>=w*32||y>=h*32))return -1;
    return grid[(int)y/32][(int)x/32];
  }

  void draw() {
    textAlign(CENTER);
    for (int j=0; j<h; j++) {
      for (int i=0; i<w; i++ ) {
        colorMode(HSB);
        fill(color(255-(grid[j][i]*31+128)%256, 155, 255));
        rect(posX+i*32, posY+j*32, 32, 32);
        fill(0);
        text(grid[j][i], posX+i*32+16, posY+j*32+20);
        colorMode(RGB);
      }
    }
  }
}