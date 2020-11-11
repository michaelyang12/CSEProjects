package lab9.scenes.ifs;
import lab9.utils.ColorUtils;
import edu.princeton.cs.introcs.StdDraw;

/**
 * Adapted from Sedgewick IFS
 * @author roncytron
 *
 */
public class Dragon extends IFS {

	// probability distribution for choosing each rule
	protected double[] getDist() {
		return new double[] { 0.787473,  0.212527 };
	}

	// update matrices
	protected double[][] getCX() {
		return new double[][]{

			 {  0.824074,  0.281482, -0.1002660 },
			 {  0.088272,  0.520988,  0.5344000 }

		};
	}
	protected double[][] getCY() {
		return new double[][] {

			{  -0.212346,  0.864198,  0.0951123 },
			{  -0.463889, -0.377778,  1.0415240 }
		};
	}

	public Dragon(double llx, double lly, double size) {
		super(llx, lly, size, ColorUtils.randomColor());
	}
	
	public static void main(String[] args) {
		StdDraw.show(10);
		Dragon t = new Dragon(0, 0, 1);
		for (int i=0; i < 25; ++i) {
			t.draw();
		}
		StdDraw.show(10);
	}

} 

