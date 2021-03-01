package lab9.scenes;

import java.util.HashSet;
import java.util.Set;

import lab9.Drawable;
import lab9.scenes.ifs.Tree;
import edu.princeton.cs.introcs.StdDraw;

public class Forest implements Drawable {
	
	private Set<Tree> trees;
	
	/**
	 * A collection (Set) of trees
	 * @param numTrees the number of trees in this Forest
	 */
	public Forest(int numTrees) {
		this.trees = new HashSet<Tree>();
		for (int i=0; i < numTrees; ++i) {
			trees.add(new Tree(2*Math.random()-1.0, 2*Math.random()-1.0, Math.random()));
		}
	}
	
	public void draw() {
		for (Tree t : trees) {
			t.draw();
		}
	}
	
	//
	// Demo a Forest
	//
	public static void main(String[] args) {
		Forest f = new Forest(80);
		StdDraw.show(10);
		f.draw();
		StdDraw.show(10);
	}

}
