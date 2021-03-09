package part1;

/**
 * This class represents a 2d triangle in the plane by three points.
 */
public class Rectangle implements Drawable{

	// *********
	// VARIABLES
	// *********

	private Point p1;
	private Point p2;

	// ************
	// CONSTRACTORS
	// ************
	
	/**
	 * This constructor build rectangle using two points.
	 * @param p1 - left x and upper y.
	 * @param p2 - right x and lower y.
	 */
	public Rectangle(Point p1, Point p2) {
		if(p1.x() > p2.x()) {
			this.p1 = new Point(p2);
			this.p2 = new Point(p1);
		}
		this.p1 = new Point(p1);
		this.p2 = new Point(p2);
	}

	/**
	 * This constructor build rectangle using another rectangle.
	 * @param other rectangle
	 */
	public Rectangle(Rectangle other) {
		this.p1 = new Point(other.p1());
		this.p2 = new Point(other.p2());
	}

	// *******
	// METHODS
	// *******

	/**
	 * This function returns the width of the rectangle.
	 * @return (double) the width.
	 */
	public double dx() {
		return Math.abs(p2.x() - p1.x());
	}
	
	/**
	 * This function returns the height of the rectangle.
	 * @return (double) the height.
	 */
	public double dy() {
		return Math.abs(p2.y() - p1.y());
	}
	
	@Override
	public boolean equals(Drawable d) {
		if( !(d instanceof Rectangle) ) return false;
		Rectangle temp = new Rectangle((Rectangle) d);
		if( !this.p1.equals(temp.p1()) || !this.p2.equals(temp.p2()) ) {
			return false;
		}
		return true;
	}

	@Override
	public boolean contains(Point p) {
		if (p.x() > p1.x() && p.x() < p2.x() && p.y() > p1.y() && p.y() < p2.y()) {
			return true;
		}
		return false;
	}

	@Override
	public double perimeter() {
		return 2 * (this.dx() + this.dy());
	}

	@Override
	public double area() {
		return this.dx() * this.dy();
	}

	@Override
	public void translate(Point p) {
		p1.translate(p);
		p2.translate(p);
	}
	
	public Point p1() {
		return p1;
	}

	public Point p2() {
		return p2;
	}

	@Override
	public String toString() {
		return "Rectangle [pointA=" + p1 + ", pointB=" + p2 + "]";
	}

}
