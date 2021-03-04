package Part_A;
/**
 * This class represents a thread that calculates a maximum between two organs
 * @author Lior Habani & Ilan Kitzio
 *
 */
public class bigThanMedianCalcThread extends Thread{

	private int a, b, max;

	public bigThanMedianCalcThread(int a, int b) {
		this.a = a;
		this.b = b;
	}

	public void run() {
		max = Math.max(a, b);
	}

	public int getMax() {
		return max;
	}



}
