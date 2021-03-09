package myMath;

public class TestPolynom {
	/**
	 * ***************************************************
	 * TEST POLYNOM CLASS
	 * ***************************************************
	 */
	public static void main(String[] args) {

		// new monom
		System.out.println("-----------------------------------------------------");
		double a = ((Math.random()*10)+1);
		a = Math.round(a*10.0)/10.0;
		int b = (int)((Math.random()*10)+1);
		Monom monom1 = new Monom(a,b);
		System.out.println("Monom1 = " + monom1.toString());
		System.out.println("-----------------------------------------------------");

		// new monom
		double c = ((Math.random()*10)+1);
		c = Math.round(c*10.0)/10.0;
		int g = (int)((Math.random()*10)+1);
		Monom monom2 = new Monom(c,g);
		System.out.println("Monom2 = " + monom2.toString());
		System.out.println("-----------------------------------------------------");

		// new monom
		double d = ((Math.random()*10)+1);
		d = Math.round(d*10.0)/10.0;
		int e = (int)((Math.random()*10)+1);
		Monom monom3 = new Monom(d,e);
		System.out.println("Monom3 = " + monom3.toString());
		System.out.println("-----------------------------------------------------");

		// new polynom zero
		Polynom polynom1 = new Polynom();
		System.out.println("Polynom1 => ");
		System.out.println(polynom1.toString());
		System.out.println("-----------------------------------------------------");

		// new polynom string
		Polynom polynom2 = new Polynom("2x+0+4x^2");
		System.out.println("Polynom2 => ");
		System.out.println(polynom2.toString());
		System.out.println("-----------------------------------------------------");

		// new polynom copy of polynom2
		Polynom polynom3 = new Polynom(polynom2);
		System.out.println("Polynom3 (copy of polynom2) => ");
		System.out.println(polynom3.toString());
		System.out.println("-----------------------------------------------------");

		/* 
		 * ADD(monom) FUNCTION -> POLYNOM
		 * lets add monom1,monom2 to polynom1 (zero polynom)
		 */
		polynom1.add(monom1);
		polynom1.add(monom2);
		System.out.println("Polynom1 after adding monom1, monom2 => ");
		System.out.println(polynom1.toString());
		System.out.println("-----------------------------------------------------");

		/* 
		 * ADD(polynom) FUNCTION -> POLYNOM
		 * lets add polynom1 to polynom2
		 */
		polynom2.add(polynom1);
		System.out.println("Polynom2 after adding Polynom1 => ");
		System.out.println(polynom2.toString());
		System.out.println("-----------------------------------------------------");

		/**
		 * SUBTRACT(polynom) FUNCTION -> POLYNOM
		 * lets subtract polynom1 from polynom2
		 */
		System.out.println("Polynom2 after substracting Polynom1 => ");
		polynom2.substract(polynom1);
		System.out.println(polynom2.toString());
		System.out.println("-----------------------------------------------------");

		/**
		 * MULTIPLY(polynom) FUNCTION -> POLYNOM
		 * lets subtract polynom3 with some string polynom
		 * we can add any string of polynom to test it
		 */
		Polynom polynom4 = new Polynom("3x+3+0+2x^2");
		System.out.print("polynom 4 =>");
		System.out.println(polynom4.toString());
		System.out.println("");
		System.out.print("polynom 3 =>");
		System.out.println(polynom3.toString());
		System.out.println("");
		System.out.println("Polynom3 after multiplying it with Polynom1 => ");
		polynom3.multiply(polynom4);
		System.out.println(polynom3.toString());
		System.out.println("-----------------------------------------------------");

		/**
		 * equals(polynom) FUNCTION -> POLYNOM
		 * lets check polynom3 with some string polynom
		 * we can add any string of polynom to test it
		 */

		Polynom polynom5 = new Polynom(polynom2);
		System.out.println("polynom2 = polynom5 ? " + polynom2.equals(polynom5));
		System.out.println("polynom2 = polynom3 ? " + polynom2.equals(polynom3));
		System.out.println("-----------------------------------------------------");

		/*
		 * isZero(polynom) FUNCTION -> POLYNOM
		 * lets check if polynom3 is zero
		 */
		System.out.println(polynom3.isZero());
		System.out.println("after multiply polynom3 with polynom zero ->");
		polynom3.multiply(new Polynom());
		System.out.println(polynom3.isZero());
		System.out.println("-----------------------------------------------------");

		/*
		 * derivative(polynom) FUNCTION -> POLYNOM
		 * use polynom4
		 */
		System.out.println(polynom4.toString());
		System.out.println("after derivative");
		Polynom polynom6 = new Polynom((Polynom)polynom4.derivative());
		System.out.println(polynom6.toString());

	}

}
