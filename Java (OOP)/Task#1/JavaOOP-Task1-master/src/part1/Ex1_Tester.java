package part1;
public class Ex1_Tester {
	public static void main(String[] a) {
		checkSignature();
		checkLogic();
	}
/**
 * this function uses some very simple tests and GUI to check some parts of Ex2a logic
 */	
	public static void checkLogic() {
		ShapeContainer sc1 = Const.getSC();
		System.out.println("area1: "+sc1.sumArea());
		ShapeContainer sc2 = new ShapeContainer(sc1);
		Point p = new Point(125,140);
		sc2.remove(p);
		sc2.translate(new Point(50,-15));
		System.out.println("area2: "+sc2.sumArea());
		System.out.println("size1: " + sc1.getContainer().size());
		System.out.println("size1: " + sc2.getContainer().size());
		sc1.minMaxPerimeter();
		
		Const.show(sc1);
		Const.show(sc2);
	}
	
/**	 this function does not follow any logic part of the code
	 it forces the right signature for all the methodes!! */
	public static void checkSignature() {
		
		// point
		Point p = new Point(1,1);
		p.translate(p);
		p.distance(p);
		
		// rectnagle
		Rectangle r = new Rectangle(p,p);
		r.p1();
		r.p2();
		r.dx();
		r.dy();
		r.equals (r);
		r.perimeter();
		r.area();
		r.translate (p);
		r.contains(p);
		
		// triangle
		Triangle t = new Triangle(p,p,p);
		t.p1();
		t.p2();
		t.p3();
		t.equals (t);
		t.perimeter();
		t.area();
		t.translate (p);
		t.contains(p);
		
		//shapeContainer
		ShapeContainer sc = new ShapeContainer();
		sc.size();
		sc.T_size();
		sc.R_size();
		sc.add (r);
		sc.add (t);
		sc.remove(p);
		sc.T_at(0);
		sc.R_at(0);
		sc.sumArea();
		sc.translate(p);
	}
}

