package lab9.scenes;

import lab9.Drawable;

public class Bubbles implements Drawable {
	
	private Circle[] bubbles;
	
	public Bubbles(int num) {
		this.bubbles = new Circle[num];
		for (int i=0; i < num; ++i) {
			bubbles[i] = new Circle(Math.random(), Math.random(), Math.random()/20);
		}
	}

	@Override
	public void draw() {
		for (Circle c : bubbles) {
			c.draw();
		}
		
	}

}
