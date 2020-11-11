package project;

import edu.princeton.cs.introcs.StdDraw;

import java.awt.*;

import static java.awt.event.KeyEvent.*;

public class Game {

    private static Snake s = new Snake();
    private static Apple apple = new Apple(Math.random(), Math.random());

    public static void setDirection() {
        if (StdDraw.isKeyPressed(VK_LEFT) && !s.right) {
            s.setMovingLeft();
        }
        if (StdDraw.isKeyPressed(VK_RIGHT) && !s.left) {
            s.setMovingRight();
        }
        if (StdDraw.isKeyPressed(VK_UP)  && !s.down) {
            s.setMovingUp();
        }
        if (StdDraw.isKeyPressed(VK_DOWN)  && !s.up) {
            s.setMovingDown();
        }
    }

    public static void eatApple() {
        double distance = Math.sqrt(Math.pow((s.getSnakeX() - apple.getX()), 2) + Math.pow((s.getSnakeY() - apple.getY()), 2));
        if (distance < 0.05) {
            apple.setX(Math.random());
            apple.setY(Math.random());
            Body plus = new Body(s.getSnakeX() + 2, s.getSnakeY() + 2, 0.025);
            s.add(plus);
        }
    }

    public static void drawBoard() {
        StdDraw.setPenColor(Color.DARK_GRAY);
        StdDraw.filledRectangle(0.5,0.5,1,1);
        StdDraw.show();
    }

    public static void main (String[] args) {
        drawBoard();
        while (!s.collision()) {
            StdDraw.enableDoubleBuffering();
            StdDraw.clear(Color.DARK_GRAY);
            apple.draw();
            setDirection();
            s.move();
            eatApple();
            s.drawSnake();
            StdDraw.show(100);
        }
    }
}
