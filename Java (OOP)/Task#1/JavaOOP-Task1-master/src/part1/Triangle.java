package part1;

/**
 * This class represents a 2d triangle in the plane by three points.
 */
public class Triangle implements Drawable{

	// *********
	// VARIABLES
	// *********
	
	private Point p1;
	private Point p2;
	private Point p3;
	
	// ************
	// CONSTRACTORS
	// ************
	
	/**
	 * This constructor builds a triangle using three points.
	 * @param p1 first point.
	 * @param p2 second point.
	 * @param p3 third point.
	 */
	public Triangle(Point p1, Point p2, Point p3) {
		this.p1 = new Point(p1);
		this.p2 = new Point(p2);
		this.p3 = new Point(p3);
	}

	/**
	 * This constructor build triangle using another triangle.
	 * @param other triangle.
	 */
	public Triangle(Triangle other) {
		this.p1 = new Point(other.p1());
		this.p2 = new Point(other.p2());
		this.p3 = new Point(other.p3());
	}

	// *******
	// METHODS
	// *******
	
	@Override
	public boolean equals(Drawable d) {
		if( !(d instanceof Triangle) ) return false;
		Triangle temp = new Triangle((Triangle) d);
		if( !this.p1.equals(temp.p1()) || !this.p2.equals(temp.p2())
				|| !this.p3.equals(temp.p3()) ) {
			return false;
		}
		return true;
	}

	@Override
	public boolean contains(Point p) {
		double d1, d2, d3;
		boolean has_neg, has_pos;

		d1 = signT(p, this.p1(), this.p2());
		d2 = signT(p, this.p2(), this.p3());
		d3 = signT(p, this.p3(), this.p1());

		has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
		has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);

		return !(has_neg && has_pos);
	}

	@Override
	public double perimeter() {
		double rib_AB = this.p1.distance(p2);
		double rib_AC = this.p1.distance(p3);
		double rib_BC = this.p2.distance(p3);
		return rib_AB + rib_AC + rib_BC;
	}

	@Override
	public double area() {
		double aX = this.p1().x() * ( this.p2().y() - this.p3().y() ) ;
		double bX = this.p2().x() * ( this.p3().y() - this.p1().y() ) ;
		double cX = this.p3().x() * ( this.p1().y() - this.p2().y() ) ;
		return Math.abs( (aX + bX + cX) / 2 );
	}
	
	public double signT (Point point, Point p1, Point p2) {
		return (point.x() - p2.x()) * (p1.y() - p2.y()) - (p1.x() - p2.x()) * (point.y() - p2.y()) ;
	}

	@Override
	public void translate(Point p) {
		p1.translate(p);
		p2.translate(p);
		p3.translate(p);
		}

	public Point p1() {
		return p1;
	}

	public Point p2() {
		return p2;
	}

	public Point p3() {
		return p3;
	}
	
	@Override
	public String toString() {
		return "Triangle [pointA=" + p1 + ", pointB=" + p2 + ", pointC=" + p3 + "]";
	}
	
}
