import java.util.*;
import java.util.concurrent.*;

class EffectManager {
  private ConcurrentLinkedQueue<Effect> effects = new ConcurrentLinkedQueue<Effect>();
  private Iterator<Effect> it;

  void generateEffect() {
    effects.add(new Effect(mouseX, mouseY));
    effects.add(new Effect(mouseX, mouseY));
  }


  void draw() {
    it = effects.iterator();
    colorMode(HSB);
    blendMode(SUBTRACT);
    noStroke();
    while (it.hasNext()) {
      Effect ef = it.next();
      if (ef.draw()) {
        effects.remove(ef);
      }
    }
    colorMode(RGB);
    blendMode(NORMAL);
    stroke(0);
  }

  class Effect {
    private int lifeTime = 30;
    private float posX;
    private float posY;
    private final float vx = random(-1, 1);
    private final float vy = random(-1, 1);

    Effect (final float posX, final float posY) {
      this.posX = posX;
      this.posY = posY;
    }

    boolean draw() {
      fill(lifeTime*8.5, 255, lifeTime*6+75);
      rect(posX-1.5, posY-1.5, 3, 3);
      posX += vx;
      posY += vy;
      fill(0);
      return lifeTime-- < 0;
    }
  }
}