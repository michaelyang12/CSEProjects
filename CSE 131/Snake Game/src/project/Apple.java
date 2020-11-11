package project;

import edu.princeton.cs.introcs.StdDraw;

import java.awt.*;

public class Apple implements Drawable {

    private double x;
    private double y;
    private double r;
    public boolean eaten;

    public Apple(double xx, double yy) {
        x = xx;
        y = yy;
        r = 0.025;
    }

    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }

    public void setX(double xx) {
        x = xx;
    }

    public void setY(double yy) {
        y = yy;
    }

    @Override
    public void draw() {
        StdDraw.setPenColor(Color.RED);
        StdDraw.filledCircle(x, y, r);
    }

}
