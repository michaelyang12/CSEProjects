package project;

import edu.princeton.cs.introcs.StdDraw;

import java.awt.*;
import java.util.*;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class Snake{

    public boolean left;
    public boolean right;
    public boolean up;
    public boolean down;

    private double r = 0.025;

    public int snakeLength;
    private List<Body> list = new LinkedList<Body>();


    public Snake () {
        double x = 0.5; // starting X
        double y = 0.5; // starting Y
        snakeLength = 3; //starting length
        //snake = new Body(x, y, r);
        for (int i = 0; i < snakeLength; i++) {
            list.add(new Body(x - i * (r*2), y, r));
        }
    }

    public void move() {
        double pos;
        double speed = 0.05;
        if (up) {
            pos = list.get(0).getY() + speed;
            list.add(0, new Body(getSnakeX(), pos, r));
            list.remove(list.size() - 1);
        }
        if (down) {
            pos = list.get(0).getY() - speed;
            list.add(0, new Body(getSnakeX(), pos, r));
            list.remove(list.size() - 1);
        }
        if (right) {
            pos = list.get(0).getX() + speed;
            list.add(0, new Body(pos, getSnakeY(), r));
            list.remove(list.size() - 1);
        }
        if (left) {
            pos = list.get(0).getX() - speed;
            list.add(0, new Body(pos, getSnakeY(), r));
            list.remove(list.size() - 1);
        }
    }

    public boolean collision() {
        boolean collide = false;
        if (getSnakeX() < 0.025 || getSnakeX() > 0.975 || getSnakeY() < 0.025 || getSnakeY() > 0.975) {
            collide = true;
        }
        for (int i = 1; i < snakeLength; i++) {
            double dist = Math.sqrt(Math.pow((getSnakeX() - list.get(i).getX()), 2) + Math.pow((getSnakeY() - list.get(i).getY()), 2));
            if (dist < 0.045) {
                return true;
            }
        }
        return collide;
    }

    public Body add(Body b) {
        snakeLength++;
        list.add(b);
        return b;
    }

    public double getSnakeX() {
        return list.get(0).getX();
    }
    public double getSnakeY() {
        return list.get(0).getY();
    }

//    public double getSnakeX(int i) {
//        return x[i];
//    }
//
//    public double getSnakeY(int i) {
//        return y[i];
//    }
//
//    public void setSnakeX(double x) {
//        this.x[0] = x;
//    }
//
//    public void setSnakeY(double y) {
//        this.y[0] = y;
//    }
//
    public void setMovingLeft() {
        this.left = true;
        this.right = false;
        this.up = false;
        this.down = false;
    }

    public void setMovingRight() {
        this.right = true;
        this.left = false;
        this.up = false;
        this.down = false;
    }

    public void setMovingUp() {
        this.up = true;
        this.right = false;
        this.left = false;
        this.down = false;
    }

    public void setMovingDown() {
        this.down = true;
        this.right = false;
        this.up = false;
        this.left = false;
    }
//
//    public int getLength() {
//        return snakeLength;
//    }
//
//    public void setLength(int length) {
//        snakeLength = length;
//    }
//
//    public boolean isTouching(int i) {
//        double distance = Math.sqrt(Math.pow((getSnakeX(0) - getSnakeX(i + 1)), 2) + Math.pow((getSnakeY(0) - getSnakeY(i + 1)), 2));
//        if (distance < 0.025) {
//            return true;
//        } else {
//            return false;
//        }
//    }
//
//    public boolean collision() {
//        boolean touch = false;
//        for (int i = 0; i < snakeLength - 1; i++) {
//            if (isTouching(i)) {
//                touch = true;
//                break;
//            }
//        }
//        return touch;
//    }
//
//    public List<Body> updateSnake() {
//        List<Body> update = new LinkedList<Body>();
//        double speed = 0.0025;
//        for (int i = 0; i < snakeLength; i++) {
//            update.add(new Body(x[i], y[i], r));
//            //snake = update.get(i);
//        }
//        if (isMovingLeft()) {
//            x[0] -= speed;
//            for (int i = 1; i < snakeLength; i++) {
//                if (x[i] > x[0] + i*di) {
//                    x[i] -= speed;
//                }
//                if (y[i] > y[0]) {
//                    y[i] -= speed;
//                }
//                if (y[i] < y[0]) {
//                    y[i] += speed;
//                }
//            }
//        }
//        if (isMovingRight()) {
//            x[0] += speed;
//            for (int i = 1; i < snakeLength; i++) {
//                if (x[i] < x[0] - i*di) {
//                    x[i] += speed;
//                }
//                if (y[i] > y[0]) {
//                    y[i] -= speed;
//                }
//                if (y[i] < y[0]) {
//                    y[i] += speed;
//                }
//            }
//        }
//        if (isMovingUp()) {
//            y[0] += speed;
//            for (int i = 1; i < snakeLength; i++) {
//                if (x[i] > x[0]) {
//                    x[i] -= speed;
//                }
//                if (x[i] < x[0]) {
//                    x[i] += speed;
//                }
//                if (y[i] < y[0] - i*di) {
//                    y[i] += speed;
//                }
//            }
//        }
//        if (isMovingDown()) {
//            y[0] -= speed;
//            for (int i = 1; i < snakeLength; i++) {
//                if (x[i] > x[0]) {
//                    x[i] -= speed;
//                }
//                if (x[i] < x[0]) {
//                    x[i] += speed;
//                }
//                if (y[i] > y[0] + i*di) {
//                    y[i] -= speed;
//                }
//            }
//        }
//
//        if (getSnakeX(0) < 0.05) {
//            setSnakeX(0.05);
//        }
//        if (getSnakeX(0) > 0.95) {
//            setSnakeX(0.95);
//        }
//        if (getSnakeY(0) < 0.05) {
//            setSnakeY(0.05);
//        }
//        if (getSnakeY(0) > 0.95) {
//            setSnakeY(0.95);
//        }
//        return update;
//    }

    public void drawSnake() {
        for (Body b : list) b.draw();
    }

}
