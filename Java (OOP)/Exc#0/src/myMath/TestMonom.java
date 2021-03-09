package myMath;

public class TestMonom {
	/**
	 * ***************************************************
	 * CHECK MONOM CLASS
	 * ***************************************************
	 */
	public static void main(String[] args) {

		/*
		 * INIT CONSTRUCTOR -> MONOM
		 * Init with random a,b (one digits only after a)
		 */
		System.out.println("-----------------------------------------------------");
		double a = ((Math.random()*10)+1);
		a = Math.round(a*10.0)/10.0;
		int b = (int)((Math.random()*10)+1);
		Monom monom1 = new Monom(a,b);
		System.out.println("Monom1 = " + monom1.toString());
		System.out.println("-----------------------------------------------------");

		// create another with the same power to use later
		double c = ((Math.random()*10)+1);
		c = Math.round(c*10.0)/10.0;
		Monom monom2 = new Monom(c,b);
		System.out.println("Monom2 = " + monom2.toString());
		System.out.println("-----------------------------------------------------");

		// create another with to use later
		double d = ((Math.random()*10)+1);
		d = Math.round(d*10.0)/10.0;
		int e = (int)((Math.random()*10)+1);
		Monom monom3 = new Monom(d,e);
		System.out.println("Monom3 = " + monom3.toString());
		System.out.println("-----------------------------------------------------");

		/* 
		 * INIT CONSTRUCTORS -> MONOM
		 * Init with copy constructor using monom1
		 */
		Monom monom1_copy = new Monom(monom1);
		System.out.println("monom1_copy = " + monom1_copy.toString());
		System.out.println("-----------------------------------------------------");

		/*
		 * ADD FUNCTION -> MONOM
		 * we'll add 'monom2' to 'monom1' 
		 * powers must be equal ! else = error
		 */
		System.out.println("Monom1 + Monom2 = " + monom1.add(monom2).toString());
		System.out.println("-----------------------------------------------------");

		/*
		 * MULTIPLY FUNCTION -> MONOM
		 * multiply 'monom2' with 'monom3'
		 */
		System.out.println("Monom2 * Monom3 = " + monom2.multiply(monom3).toString());
		System.out.println("-----------------------------------------------------");

		/*
		 * DERIVATIVE FUNCTION -> MONOM
		 * derivative monom3
		 */
		monom3.derivative();
		System.out.println("Monom3 derivative = " + monom3);
		System.out.println("-----------------------------------------------------");
	}



}
