package part1;
import java.util.ArrayList;

public class ShapeContainer {

	// *********
	// VARIABLES
	// *********
	
	private ArrayList<Drawable> container;
	int num_of_triangles, num_of_rectangles;

	// ************
	// CONSTRACTORS
	// ************
	
	/**
	 * This constructor build a new class of ShapeContainer with an empty array.
	 */
	public ShapeContainer() {
		container = new ArrayList<Drawable>();
		num_of_triangles = 0;
		num_of_rectangles = 0;
	}

	/**
	 * This construcotr build a new class of ShapeContainer using the values of other ShapeContainer.
	 * @param other ShapeContainer.
	 */
	public ShapeContainer(ShapeContainer other) {
		container = new ArrayList<Drawable>();
		for(Drawable d : other.getContainer()) {
			if(d instanceof Triangle) {
				Triangle temp = new Triangle((Triangle) d);
				this.container.add(temp);
			}
			else if(d instanceof Rectangle) {
				Rectangle temp = new Rectangle((Rectangle) d);
				this.container.add(temp);
			}
		}
		num_of_triangles = other.getNum_of_triangles();
		num_of_rectangles = other.getNum_of_rectangles();
	}

	// *******
	// METHODS
	// *******
	
	/**
	 * This functions adds the given object to the container 
	 * (without creating a new copy of the object)
	 * in addition - updating the number of shapes, triangles \ rectangles 
	 * @param d - Rectangle \ Triangle .
	 */
	public void add(Drawable d) {
		container.add(d);
		if(d instanceof Triangle) num_of_triangles++;
		if(d instanceof Rectangle) num_of_rectangles++;
	}

	/**
	 * This functions removes triangles and rectangles containing the point p
	 * in addition - updating the number of shapes, triangles \ rectangles 
	 * @param p - Point.
	 */
	public void remove(Point p) {
		if(this.isEmpty()) {
			System.out.println("The container is empty!");
			return;
		}
		ArrayList<Drawable> temp = (ArrayList<Drawable>) this.container.clone();
		for(Drawable d : temp) {
			if(d.contains(p)) {
				if(d instanceof Triangle) num_of_triangles--;
				else if(d instanceof Rectangle) num_of_rectangles--;
				this.container.remove(d);
			}
		}
	}

	/**
	 * This function returns a copy of triangle number i (start from number 0)
	 * @param i - triangle number 'i' .
	 * @return copy of triangle number 'i' .
	 */
	public Triangle T_at(int i) {
		if(i >= 0 || i < num_of_triangles) {
			int counter = -1;
			for(Drawable d : this.container) {
				if(d instanceof Triangle) {
					counter++;
					if(counter == i) {
						Triangle temp = new Triangle((Triangle) d);
						return temp;
					}
				}
			}
		}
		return null;
	}

	/**
	 * This function returns a copy of rectangle number i (start from number 0)
	 * @param i - rectangle number 'i' .
	 * @return copy of rectangle number 'i' .
	 */
	public Rectangle R_at(int i) {
		if(i >= 0 || i < num_of_rectangles) {
			int counter = -1;
			for(Drawable d : this.container) {
				if(d instanceof Rectangle) {
					counter++;
					if(counter == i) {
						Rectangle temp = new Rectangle((Rectangle) d);
						return temp;
					}
				}
			}
		}
		return null;
	}

	/**
	 * This function returns the sum of the areas of all the triangles and rectangles
	 * @return (double) sum.
	 */
	public double sumArea() {
		double area = 0;
		for(Drawable d : this.container) area += d.area();
		return area;
	}

	/**
	 * This function returns the number of stored shapes in the container
	 * @return (int) the number of the shapes int the container
	 */
	public int size() {
		return this.container.size();
	}
	
	/**
	 * This function returns the number of stored triangles in the container
	 * @return (int) the number of the triangles.
	 */
	public int T_size() {
		return num_of_triangles;
	}

	/**
	 * This function returns the number of stored rectangles in the container
	 * @return (int) the number of the rectangles.
	 */
	public int R_size() {
		return num_of_rectangles;
	}

	/**
	 * This function checks if the container is empty or not.
	 * @return true if empty and false if not.
	 */
	public boolean isEmpty() {
		return this.container.isEmpty();
	}

	/**
	 * This function translates (mutator) all the shapes by Point
	 * @param p - Point.
	 */
	public void translate(Point p) {
			for(Drawable d : container) d.translate(p);
	}

	/**
	 * This function calculates and prints the minimum and maximum perimeter
	 * of the shapes (triangles and rectangles)	 
	 */
	public void minMaxPerimeter() {
		if(!this.isEmpty()) {
			double min, max;
			min = max = this.container.get(0).perimeter();
			int comp = 1;
			for(int i = 1 ; i < this.size() ; i++) {
				if(this.container.get(i).perimeter() < min) {
					min = this.container.get(i).perimeter();
					comp++;
				}
				else if(this.container.get(i).perimeter() > max) {
					max = this.container.get(i).perimeter();
					comp++;
				}
			}
			System.out.println("number of comparisons : " + comp);
			System.out.println("max perimeter : " + max);
			System.out.println("min perimeter : " + min);
		}
		else System.out.println("The shape container is empty!");
	}

	public ArrayList<Drawable> getContainer() {
		return container;
	}

	public int getNum_of_triangles() {
		return num_of_triangles;
	}

	public int getNum_of_rectangles() {
		return num_of_rectangles;
	}
	
}
