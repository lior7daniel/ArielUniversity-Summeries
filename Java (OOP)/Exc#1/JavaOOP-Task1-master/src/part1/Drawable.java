package part1;

/**
 * This class is interface 
 * @author Lior
 *
 */
public interface Drawable {
	
	/**
	 * This functions checks if the shapes are equals.
	 * @param d shape that implements Drawable.
	 * @return true if equal and false if not.
	 */
	public boolean equals(Drawable d);
	/**
	 * This function checks if the shape contains the point.
	 * @param p - point to check.
	 * @return true if the point is inside the shape or false if not.
	 */
	public boolean contains(Point p);
	/**
	 * This function calculates the perimeter of the shape.
	 * @return perimeter.
	 */
	public double perimeter();
	/**
	 * This function calculates the area of the shape.
	 * @return area.
	 */
	public double area();
	/**
	 * This function transfer the shape to the point.
	 * @param p point.
	 */
	public void translate(Point p);
	
}
