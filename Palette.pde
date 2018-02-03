class Palette {
  private int[][] grid;
  float posX;
  float posY;
  int w;
  int h;
  int draw = 0;

  Palette(final float posX, final float posY, final int w, final int h) {
    this.w = w;
    this.h = h;
    this.posX = posX;
    this.posY = posY;
    grid = new int[h][w];
    for (int j=0; j<h; j++) {
      for (int i=0; i<w; i++) {
        grid[j][i]=j*w+i;
      }
    }
  }

  void setPalette(final float x, final float y) {
    if ((x<0||y<0) || (x>=w*32||y>=h*32))return;
    draw = grid[(int)y/32][(int)x/32];
  }

  void draw() {
    fill(255,255,200);
    rect(posX-16,posY-64,w*32+32,h*32+80);
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
    colorMode(HSB);
    fill(color(255-(draw*31+128)%256, 155, 255));
    rect(posX+16, posY-48, 32, 32);
    fill(0);
    text(draw, posX+32, posY-48+20);
    colorMode(RGB);
  }
}