import javax.swing.*;
import java.awt.*;
import processing.awt.PSurfaceAWT;

private ButtonManager buttonManager;
private GridCanvas gridCanvas;
private Palette palette;
private Pen pen;
private String path = "export/";

void setup() {
  frameRate(60);
  size(928, 576);

  background(228, 255, 255);
  MyButtonListener mbl = new MyButtonListener();
  palette = new Palette(32, 288, 6, 5);
  pen = new Pen(palette);
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
    if (size[0] < 928)size[0] = 928;
    if (size[0] > displayWidth)size[0] = displayWidth;
    config = in[1].split("\\s+");
    size[1] = Integer.parseInt(config[1]);
    if (size[1]<576)size[1] = 576;
    if (size[1]>displayHeight)size[1] = displayHeight;
    try {
      path = in[2].split("\\s+")[1];
    }
    catch(ArrayIndexOutOfBoundsException e) {
      path = "";
    }
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
  outfile.println("height 576");
  outfile.print("path export/");
  outfile.flush();
  outfile.close();
}

void draw() {
  background(228, 255, 255);
  if (gridCanvas!=null) {
    gridCanvas.draw();
  }
  pen.draw();
  palette.draw();
  buttonManager.draw();
}

class MyButtonListener implements ActionListener {
  void actionPerformed(ActionEvent event) {
    if (event.getSource() == buttonManager.createButton) {
      gridCanvas = new GridCanvas(palette.posX + palette.w*32+32, 32, buttonManager.getWidth(), buttonManager.getHeight());
      pen.setCanvas(gridCanvas);
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
      pen.setCanvas(gridCanvas);
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
      PrintWriter outfile = createWriter(path+buttonManager.saveFileNameText.getText()+".txt");
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
      String tmp = buttonManager.drawModeButton.getText();
      buttonManager.drawModeButton.setText(pen.changeDrawMode(tmp));
    }
  }
}