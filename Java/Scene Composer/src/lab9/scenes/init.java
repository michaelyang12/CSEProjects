package lab9.scenes;

import edu.princeton.cs.introcs.StdDraw;
import lab9.Drawable;
import lab9.scenes.ifs.*;

import java.util.HashSet;
import java.util.Set;

public class init implements Drawable{

    private Set<Drawable> all;

    /**
     * A collection (Set) of trees
     * @param numTrees the number of trees in this Forest
     */
    public init(int numDragons, int numTrees, int numLeaves) {
        this.all = new HashSet<Drawable>();

        for (int i=0; i < numDragons; ++i) {
            all.add(new Dragon(2*Math.random()-1.0, 2*Math.random()-1.0, Math.random()));
        }
        for (int i=0; i < numTrees; ++i) {
            all.add(new Tree(2 * Math.random() - 1.0, 2 * Math.random() - 1.0, Math.random()));
        }

        for (int i=0; i < numLeaves; ++i) {
            all.add(new Leaf(2*Math.random()-1.0, 2*Math.random()-1.0, Math.random()));
        }
    }

    public void draw() {
        for (Drawable d : all) {
            d.draw();
        }
    }

    //
    // Demo a Forest
    //
    public static void main(String[] args) {
        init i = new init(80, 50, 50);
        StdDraw.show(10);
        i.draw();
        StdDraw.show(10);
    }
}
