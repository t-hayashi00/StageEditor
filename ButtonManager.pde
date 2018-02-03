import javax.swing.*;
import javax.swing.InputVerifier;
import java.awt.Canvas;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

class ButtonManager {
  final ActionListener al;
  int posX;
  int posY;
  JLayeredPane pane;

  JTextField widthText;
  JTextField heightText;
  JButton createButton;

  JTextField loadFileNameText;
  JButton loadButton;

  JTextField saveFileNameText;
  JButton saveButton;

  JButton drawModeButton;

  ButtonManager(final float posX, final float posY, final ActionListener al) {
    this.posX = (int)posX;
    this.posY = (int)posY;
    this.al = al;
    Canvas canvas = (Canvas) surface.getNative();
    pane = (JLayeredPane) canvas.getParent().getParent();
    initCreateButton();
    initLoadButton();
    initSaveButton();
    initDrawModeButton();
  }

  private void initCreateButton() {
    widthText = new JTextField("20");
    widthText.setBounds(posX, posY, 48, 28);
    pane.add(widthText);

    JLabel multiLabel = new JLabel(" ×");
    multiLabel.setBounds(posX+48, posY, 24, 27);
    pane.add(multiLabel);

    heightText = new JTextField("15");
    heightText.setBounds(posX+62, posY, 48, 28);
    pane.add(heightText);

    createButton = new JButton("作る");
    createButton.setBounds(posX+132, posY, 62, 28);
    createButton.addActionListener(al);
    pane.add(createButton);
  }

  private void initLoadButton() {
    loadFileNameText = new JTextField("ここにファイル名");
    loadFileNameText.setBounds(posX, posY+38, 110, 28);
    pane.add(loadFileNameText);

    loadButton = new JButton("開く");
    loadButton.setBounds(posX+132, posY+38, 62, 28);
    loadButton.addActionListener(al);
    pane.add(loadButton);
  }

  private void initSaveButton() {
    saveFileNameText = new JTextField("ここにファイル名");
    saveFileNameText.setBounds(posX, posY+114, 110, 28);
    pane.add(saveFileNameText);

    saveButton = new JButton("保存");
    saveButton.setBounds(posX+132, posY+114, 62, 28);
    saveButton.addActionListener(al);
    pane.add(saveButton);
  }

  private void initDrawModeButton() {
    drawModeButton = new JButton("PEN");
    drawModeButton.addActionListener(al);
    pane.add(drawModeButton);
  }

  int getWidth() {
    int result = 20;
    try {
      result = Integer.parseInt(widthText.getText());
      if (result <= 0)result = 20;
      if (result > 200)result = 200;
      widthText.setText(Integer.toString(result));
    }
    catch (NumberFormatException e) {
      widthText.setText("20");
    }
    return result;
  }

  int getHeight() {
    int result = 15;
    try {
      result = Integer.parseInt(heightText.getText());
      if (result <= 0)result = 15;
      if (result > 150)result = 150;
      heightText.setText(Integer.toString(result));
    }
    catch (NumberFormatException e) {
      heightText.setText("15");
    }
    return result;
  }
  void draw() {
    fill(255,255,200);
    rect(posX-16,posY-16,7*32,96);
    rect(posX-16,posY+96,7*32,64);
  }
}