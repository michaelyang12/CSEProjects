package lab9;

import java.util.*;

import cse131.ArgsProcessor;
import edu.princeton.cs.introcs.Draw;
import lab9.Drawable;
import lab9.scenes.*;
import lab9.scenes.ifs.*;
import edu.princeton.cs.introcs.StdDraw;

public class SceneComposer {

	public static Map<String, Drawable> record = new HashMap<>();
	public static Map<String, Drawable> drawing = new HashMap<>();

//	public SceneComposer() {
//		this.record =
//		this.drawing =
//		this.dList =
//		drawing.put("b", new Bubbles(2));
//		drawing.put("d", new Dragon(2*Math.random()-1.0, 2*Math.random()-1.0, Math.random()));
//		drawing.put("l", new Leaf(2*Math.random()-1.0, 2*Math.random()-1.0, Math.random()));
//	}
//	public void draw() {
//		for (Drawable d : dList) {
//			d.draw();
//		}
//	}

//	public static void recording(String resp) {
//		if (resp.equals("clear")) {
//			StdDraw.clear();
//			dList.clear();
//		}
//		if (resp.equals("b")) {
//			Bubbles b = new Bubbles(9);
//			dList.add(b);
//			b.draw();
//		}
//		if (resp.startsWith("t")) {
//			Tree t = new Tree(0.5, 0.75, 1);
//			dList.add(t);
//			t.draw();
//		}
//		if (resp.startsWith("l")) {
//			Leaves l = new Leaves(80);
//			dList.add(l);
//			l.draw();
//		}
//		if (resp.equals("d")) {
//			Dragon d = new Dragon(0.5, 0.5, 1);
//			dList.add(d);
//			d.draw();
//		}
//	}

//	public static void saveRecording(String saveName) {
//		for (Drawable d : dList) {
//			record.put(saveName, d);
//		}
//		save.add(saveName);

	public static boolean recording (String resp) {
		if (resp.equals("ron")) {
			return true;
		} else {
			return false;
		}
	}

	public static void main(String[] args) {

		drawing.put("b", new Bubbles(5));
		drawing.put("d", new Dragon(Math.random(), Math.random(), Math.random()));
		drawing.put("l", new Leaf(Math.random(), Math.random(), Math.random()));
		ArgsProcessor ap = new ArgsProcessor(args);
		init.main(args);
		while(true) {
			String resp = ap.nextString("Express yourself");
			StdDraw.show(10);
			if (drawing.containsKey(resp)) {
				drawing.get(resp).draw();
			}
			if (resp.equals("clear")) {
				StdDraw.clear();
			}
			if (resp.equals("end")) {
				break;
			}
			if (recording(resp)) {
				List<Drawable> dList = new LinkedList<>();
				String recResp = ap.nextString("Express yourself (recording)");
				while(!recResp.equals("roff")) {
					dList.add(drawing.get(recResp));
					drawing.get(recResp).draw();
					StdDraw.show();
					recResp = ap.nextString("Express yourself (recording)");
				}
				String saveName = ap.nextString("What would you like to call this recording");
				Sequence s = new Sequence(dList);
				drawing.put(saveName, s);
			}
//			if (drawing.containsKey(resp)) {
//				drawing.get(resp).draw();
//			}
//			String resp = ap.nextString("Express yourself");
//			if (resp.equals("init")) {
//				init.main(args);
//			}
//			if (resp.equals("clear")) {
//				StdDraw.clear();
//			}
//			if (resp.equals("b")) {
//				StdDraw.show(10);
//				Bubbles b = new Bubbles(9);
//				b.draw();
//				StdDraw.show(10);
//			}
//			if (resp.startsWith("t")) {
//				StdDraw.show(10);
//				Tree t = new Tree(0.5, 0.75, 1);
//				t.draw();
//				StdDraw.show(10);
//			}
//			if (resp.startsWith("l")) {
//				StdDraw.show(10);
//				Leaves l = new Leaves(80);
//				l.draw();
//				StdDraw.show(10);
//			}
//			if (resp.equals("d")) {
//				StdDraw.show(10);
//				Dragon d = new Dragon(0.5, 0.5, 1);
//				d.draw();
//				StdDraw.show(10);
//			}
//			if (resp.equals("ron")) {
//				while (!(resp.equals("roff"))) {
//					resp = ap.nextString("Express yourself");
//					if (resp.equals("clear")) {
//						StdDraw.clear();
//						//dList.clear();
//					}
//					if (resp.equals("b")) {
//						StdDraw.show(10);
//						Bubbles b = new Bubbles(9);
//						//dList.add(b);
//						b.draw();
//						StdDraw.show(10);
//					}
//					if (resp.startsWith("t")) {
//						StdDraw.show(10);
//						Tree t = new Tree(0.5, 0.75, 1);
//						//dList.add(t);
//						t.draw();
//						dList.add(t);
//						StdDraw.show(10);
//					}
//					if (resp.startsWith("l")) {
//						StdDraw.show(10);
//						Leaves l = new Leaves(80);
//						dList.add(l);
//						l.draw();
//						StdDraw.show(10);
//					}
//					if (resp.equals("d")) {
//						StdDraw.show(10);
//						Dragon d = new Dragon(0.5, 0.5, 1);
//						d.draw();
//						StdDraw.show(10);
//						dList.add(d);
//					}
//				}
//			}
//			if (resp.equals("roff")) {
//				String saveName = ap.nextString("What would you like to call this recording");
//				Sequence s = new Sequence(dList);
//				record.put(saveName, s);
//			}
////					for (Drawable d : dList) {
////					record.put(saveName, d);
////				}
////				save.add(saveName);
////			}
////			for (String s : save) {
////				if (resp.equals(s)) {
////					record.get(save).draw();
////				}
////			}
//			if (resp.equals("end")) {
//				break;
//			}
			StdDraw.show(10);

		}

	}
//			if (resp.equals("ron")) {
//				while (!(resp.equals("roff"))) {
//					if (resp.equals("init")) {
//						init.main(args);
//					}
//					if (resp.equals("clear")) {
//						StdDraw.clear();
//					}
//					recording(, count);
//					count++;
//				}
//				if (resp.equals("stop")) {
//					break;
//				}
//			} else {


		//
		// for demo only, remove this code and write your own to do what
		//   is needed for this lab
//		while(true) {
//			StdDraw.show(10);
//			for (int i=0; i < 10; ++i) {
//				Forest f = new Forest(5);
//				f.draw(); f.draw(); f.draw(); f.draw();
//				Leaves l = new Leaves(5);
//				l.draw(); l.draw();
//			}
//			Bubbles b = new Bubbles(10);
//			b.draw();
//			StdDraw.show(10);
//			String resp = ap.nextString("Again?");
//			if (resp.equals("no")) {
//				break;
//			}
//			else {
//				new Clear().draw();
//			}
//		}
		//
		// end of demo code
		//

}
