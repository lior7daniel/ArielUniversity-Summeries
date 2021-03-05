package part1;
/**
 * this class represents a 2d point in the plane. <br>
 * supports several operations on points in the plane.
 */
public class Point implements Drawable{

	// ******** private data ********
	private double _x, _y;

	// ********* constructors ********
	public Point (double x1, double y1) {
		_x = x1;
		_y = y1;
	}

	/**
	 * copy constructor:  
	 * 1)here a direct access to a class memeber is performed,
	 *   this will be done only in a constractor to achieve an identical copy
	 * 2) using a call to another constractor code is not written twice
	 * @param p other point
	 */
	public Point (Point p) { this(p._x, p._y);}

	// ********** public methodes *********
	public double x() {return _x;}
	public double y() {return _y;}

	/** @return a String contains the Point data*/
	public String toString()  {
		return "[" + _x + "," + _y+"]";
	}

	/**
	 * logical equals 
	 * @param p other Object (Point).
	 * @return true iff p instance of Point and logicly the same)
	 */
	public boolean equals (Point p) {
		return p!=null && p._x == _x && p._y==_y; }

	@Override
	public boolean equals(Drawable d) {
		if( !(d instanceof Point) ) return false;
		return this.equals((Point) d);
	}

	@Override
	public boolean contains(Point p) {
		return equals(p);
	}

	@Override
	public double perimeter() {
		return 0;
	}

	@Override
	public double area() {
		return 0;
	}

	@Override
	public void translate(Point p) {
		this._x += p.x();
		this._y += p.y();
	}

	/**
	 * This function returns the length between two points
	 * @param p2 - other point.
	 * @return (double) the distance.
	 */
	public double distance(Point p2) {
		double dx = this._x - p2.x();
		double dy = this._y - p2.y();
		return Math.sqrt(dx*dx + dy*dy);
	}


}// class Point