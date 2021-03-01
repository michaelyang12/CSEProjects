package project;

import edu.princeton.cs.introcs.StdDraw;

import java.awt.*;

public class Body implements Drawable {

    private double x;
    private double y;
    private double r;


    public Body(double x, double y, double r) {
        this.x = x;
        this.y = y;
        this.r = r;
    }

    public double getX() {
        return this.x;
    }
    public double getY() {
        return this.y;
    }
    public void setX(double xx) {
        x = xx;
    }

    public void setY(double yy) {
        y = yy;
    }

    @Override
    public void draw() {
        StdDraw.setPenColor(Color.GREEN);
        StdDraw.filledCircle(x, y, r);
    }

}
