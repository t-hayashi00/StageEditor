class Pen {
  private GridCanvas gridCanvas;
  private Palette palette;
  private float fromX, fromY;
  private String drawMode = "PEN";
  private boolean prePressed = false;
  Pen (final Palette palette) {
    this.palette = palette;
  }
  void setCanvas(final GridCanvas gridCanvas) {
    this.gridCanvas = gridCanvas;
  }

  String changeDrawMode(final String nowDrawMode) {
    fromX = mouseX;
    fromY = mouseY;
    switch(nowDrawMode) {
    case "PEN":
      drawMode = "RECT";
      break;
    case "RECT":
      drawMode = "LINE";
      break;
    case "LINE":
    default:
      drawMode = "PEN";
      break;
    }
    return drawMode;
  }

  void draw() {
    if (gridCanvas != null) {
      switch(drawMode) {
      default://"PEN"
        drawPen();
        break;
      case "LINE":
        drawLine();
        break;
      case "RECT":
        drawRect();
        break;
      }
    }
    if (mousePressed) {
      switch(mouseButton) {
      case LEFT:
        palette.setPalette(mouseX-palette.posX, (mouseY-palette.posY));
        break;
      case RIGHT:
        if (gridCanvas!=null && gridCanvas.getGrid(mouseX-gridCanvas.posX, (mouseY-gridCanvas.posY))>=0) {
          palette.draw = gridCanvas.getGrid(mouseX-gridCanvas.posX, (mouseY-gridCanvas.posY));
        }
        break;
      case 3://WHEEL
        if (gridCanvas!=null) {
          gridCanvas.posX += mouseX-pmouseX;
          gridCanvas.posY += mouseY-pmouseY;
        }
        break;
      default:
      }
    }
  }

  void drawPen() {
    if (mousePressed && mouseButton==LEFT) {
      if (prePressed) {
        float rx = (mouseX-pmouseX);
        float ry = (mouseY-pmouseY);
        final float DIV=sqrt((rx*rx)+(ry*ry))/3;
        rx = (mouseX-pmouseX)/DIV;
        ry = (mouseY-pmouseY)/DIV;
        for (int i=1; i < DIV; i++) {
          gridCanvas.setGrid((pmouseX+rx*(i+1))-gridCanvas.posX, (pmouseY+ry*(i+1))-gridCanvas.posY, palette.draw);
        }
      }
      gridCanvas.setGrid(mouseX-gridCanvas.posX, mouseY-gridCanvas.posY, palette.draw);
      prePressed = true;
    } else {
      prePressed = false;
    }
  }

  void drawLine() {
    if (mousePressed && mouseButton==LEFT) {
      if (!prePressed) {
        fromX = mouseX;
        fromY = mouseY;
      }
      fill(0);
      line(fromX, fromY, mouseX, mouseY);
      prePressed = true;
    } else {
      if (prePressed) {
        float rx = (mouseX-fromX);
        float ry = (mouseY-fromY);
        final float DIV=sqrt((rx*rx)+(ry*ry))/3;
        rx = (mouseX-fromX)/DIV;
        ry = (mouseY-fromY)/DIV;
        for (int i=0; i < DIV; i++) {
          gridCanvas.setGrid((fromX+rx*i)-gridCanvas.posX, (fromY+ry*i)-gridCanvas.posY, palette.draw);
        }
        gridCanvas.setGrid(mouseX-gridCanvas.posX, mouseY-gridCanvas.posY, palette.draw);
      }
      prePressed = false;
    }
  }

  void drawRect() {
    if (mousePressed && mouseButton==LEFT) {
      if (!prePressed) {
        fromX = mouseX;
        fromY = mouseY;
      }
      noFill();
      stroke(0);
      rect(fromX, fromY, mouseX-fromX, mouseY-fromY);
      prePressed = true;
    } else {
      if (prePressed) {
        final float DIV_X = abs(mouseX-fromX);
        final float DIV_Y = abs(mouseY-fromY);
        float rx = (mouseX-fromX) / abs(mouseX-fromX);
        float ry = (mouseY-fromY) / abs(mouseY-fromY);
        if (mouseX-fromX==0)rx=0;
        if (mouseY-fromY==0)ry=0;
        for (int j = 0; j <= DIV_Y; j++) {
          for (int i = 0; i <= DIV_X; i++) {
            gridCanvas.setGrid((fromX+i*rx)-gridCanvas.posX, (fromY+j*ry)-gridCanvas.posY, palette.draw);
          }
        }
        gridCanvas.setGrid(mouseX-gridCanvas.posX, mouseY-gridCanvas.posY, palette.draw);
      }
      prePressed = false;
    }
  }
}