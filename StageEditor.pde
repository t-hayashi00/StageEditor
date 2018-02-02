import javax.swing.*;
import java.awt.*;
import processing.awt.PSurfaceAWT;

JLayeredPane pane;
JTextField field;
JTextArea area;

GridCanvas gridCanvas;
Palette palette;
ButtonManager buttonManager;
boolean prePressed = false;
boolean redrawReq = false;
float fromX, fromY;
String drawMode = "PEN";

void setup() {
  frameRate(60);
  size(928, 576);

  background(228, 255, 255);
  MyButtonListener mbl = new MyButtonListener();
  palette = new Palette(32, 288, 6, 5);
  buttonManager = new ButtonManager(32, 48, mbl);
  buttonManager.drawModeButton.setBounds((int)palette.posX+80, (int)palette.posY-48, 96, 33);
  palette.draw();
  buttonManager.draw();

  surface.setResizable(true); 
  int[] size = loadConfig();
  PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();

  smoothCanvas.getFrame().setSize(size[0], size[1]);
}
int[] loadConfig() {
  int[] size = {928, 576};
  String[] in = loadStrings("config.ini");
  if (in == null) {
    makeConfig();
    System.err.println("Created the config file.");
    return size;
  }
  try {
    String[] config = in[0].split("\\s+");
    size[0] = Integer.parseInt(config[1]);
    if (size[0]<928)size[0] = 928;
    if (size[0]>displayWidth)size[0] = displayWidth;
    config = in[1].split("\\s+");
    size[1] = Integer.parseInt(config[1]);
    if (size[1]<576)size[1] = 576;
    if (size[1]>displayHeight)size[1] = displayHeight;
    return size;
  }
  catch(ArrayIndexOutOfBoundsException e) {
    System.err.println("This config file is invalid.");
    makeConfig();
    System.err.println("Fixed the config file.");
    return size;
  }
  catch(NumberFormatException e) {
    System.err.println("This config file is invalid.");
    makeConfig();
    System.err.println("Fixed the config file.");
    return size;
  }
}

private void makeConfig() {
  PrintWriter outfile = createWriter("config.ini");
  outfile.println("width 928");
  outfile.print("height 576");
  outfile.flush();
  outfile.close();
}

void draw() {
  background(228, 255, 255);
  if (gridCanvas!=null) {
    gridCanvas.draw();
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
    if (mousePressed) {
      switch(mouseButton) {
      case LEFT:
        palette.setPalette(mouseX-palette.posX, (mouseY-palette.posY));
        break;
      case RIGHT:
        if (gridCanvas.getGrid(mouseX-gridCanvas.posX, (mouseY-gridCanvas.posY))>=0) {
          palette.draw = gridCanvas.getGrid(mouseX-gridCanvas.posX, (mouseY-gridCanvas.posY));
        }
        break;
      case 3://WHEEL
        gridCanvas.posX+=mouseX-pmouseX;
        gridCanvas.posY+=mouseY-pmouseY;
        break;
      default:
      }
    }
    if (redrawReq) {
      background(228, 255, 255);
      redrawReq = false;
    }
  }
  palette.draw();
  buttonManager.draw();
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

class MyButtonListener implements ActionListener {

  JTextField textField;

  void setTextField(JTextField textField) {
    this.textField = textField;
  }

  void actionPerformed(ActionEvent event) {
    if (event.getSource() == buttonManager.createButton) {
      gridCanvas = new GridCanvas(palette.posX + palette.w*32+32, 32, buttonManager.getWidth(), buttonManager.getHeight());
      redrawReq = true;
    }
    if (event.getSource() == buttonManager.loadButton) {
      String[] in = loadStrings("export/"+buttonManager.loadFileNameText.getText()+".txt");
      if (in == null) {
        buttonManager.loadFileNameText.setText("ないです");
        buttonManager.saveFileNameText.setText("あっ、ない");
        return;
      }
      buttonManager.saveFileNameText.setText(buttonManager.loadFileNameText.getText());
      gridCanvas = new GridCanvas(palette.posX + palette.w*32+32, 32, in);
      redrawReq = true;
    }
    if (event.getSource() == buttonManager.saveButton) {
      if (gridCanvas==null) {
        buttonManager.saveFileNameText.setText("何を保存しろと");
        return;
      }
      String fileName = buttonManager.saveFileNameText.getText();
      switch(fileName) {
      case "":
      case "ここにファイル名":
      case "あっ、ない":
      case "何を保存しろと":
      case "ファイル名決めて":
        fileName = " ";
      default:
        if (fileName.matches("[　]*\\s+[　]*|\\s*[　]+\\s*")) {
          buttonManager.saveFileNameText.setText("ファイル名決めて");
          return;
        }
      }
      PrintWriter outfile = createWriter("export/"+buttonManager.saveFileNameText.getText()+".txt");
      try {
        for (int j=0; j<gridCanvas.grid.length; j++) {
          for (int i=0; i<gridCanvas.grid[0].length; i++) {
            String space = " ";
            if (i-gridCanvas.grid[0].length == -1)space = "";
            outfile.print(gridCanvas.grid[j][i]+space);
          }
          outfile.println("");
        }
        outfile.flush();
        outfile.close();
      }  
      catch(ArrayIndexOutOfBoundsException e) {
        System.err.println("save is failed.");
        outfile.flush();
        outfile.close();
      }
    }

    if (event.getSource() == buttonManager.drawModeButton) {
      fromX = mouseX;
      fromY = mouseY;
      String tmp = buttonManager.drawModeButton.getText();
      switch(tmp) {
      case "PEN":
        drawMode = "RECT";
        buttonManager.drawModeButton.setText("RECT");
        break;
      case "RECT":
        drawMode = "LINE";
        buttonManager.drawModeButton.setText("LINE");
        break;
      case "LINE":
      default:
        drawMode = "PEN";
        buttonManager.drawModeButton.setText("PEN");
        break;
      }
    }
  }
}