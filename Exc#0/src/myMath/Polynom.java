package myMath;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import myMath.Monom;
/**
 * This class represents a Polynom with add, multiply functionality, it also should support the following:
 * 1. Riemann's Integral: https://en.wikipedia.org/wiki/Riemann_integral
 * 2. Finding a numerical value between two values (currently support root only f(x)=0).
 * 3. Derivative
 * 
 * @author Boaz
 *
 */
public class Polynom implements Polynom_able{

	// VARS

	private List<Monom> monomials;

	// CONST
	/**
	 * Constructor that creates a new polynomial equal to zero.
	 */
	public Polynom() {
		Monom m = new Monom(0.0,1);
		this.monomials = new ArrayList<Monom>();
		this.monomials.add(m);
		removeZero(this.monomials);
	}
	/**
	 * a Constructor that creates a new polynomial that is a deep copy of the another.
	 * @param p
	 */
	public Polynom(Polynom p) {
		this.monomials = new ArrayList<Monom>();
		Iterator<Monom> itr = p.monomials.iterator();
		while (itr.hasNext()) {
			this.monomials.add(itr.next());
		}
		Collections.sort(this.monomials, new Monom_Comperator());
		removeZero(this.monomials);
	}
	/**
	 * a Constructor that reads string and creates a new polynomial.
	 * @param str
	 */
	public Polynom(String str) {
		for (int k = 0; k < str.length() ; k++) {
			if((str.charAt(k) < 48 || str.charAt(k) > 57)){
				if((str.charAt(k) != '.' && str.charAt(k) != 'x' && str.charAt(k) != 'X' && str.charAt(k) != '^' && str.charAt(k) != '*' && str.charAt(k) != '-' && str.charAt(k) != '+')) {
					throw new IllegalArgumentException("Illegal polynom"); 
				}
			}
		}
		this.monomials = new ArrayList<Monom>();
		String tempcoef = "0";
		String temppow = "0";
		for(int i=0;i<str.length();i++) {
			if(str.charAt(i) == '-') {
				tempcoef = "-";
			}
			boolean flag1 = true;
			while( ((str.charAt(i) >= 48 && str.charAt(i) <= 57) || str.charAt(i) == '.') && flag1 == true) {
				if(!tempcoef.contains("-") && i != 0) {
					if(str.charAt(i-1) == '-') tempcoef = "-";
				}
				tempcoef += str.charAt(i);
				if(i+1 < str.length()) {
					i++;
				}
				else flag1 = false;
			}
			if(str.charAt(i) == 'x' || str.charAt(i) == 'X') {
				if(i==0) tempcoef += "1";
				if(i+1 < str.length()) {
					i++;
					if(str.charAt(i) == '^' && i+1 < str.length()) i++;
					boolean flag = true;
					while((str.charAt(i) >= 48 && str.charAt(i) <= 57 && flag == true) || ((str.charAt(i) == '-' || str.charAt(i) == '+') && flag == true) ) {
						if((str.charAt(i) == '-' || str.charAt(i) == '+')) {
							temppow += 1;
							flag = false;
						}
						else if(str.charAt(i) >= 48 && str.charAt(i) <= 57) {
							temppow += str.charAt(i);
							if(i+1 < str.length()) i++;
							flag = false;
						}
					}
				}
				else temppow += "1";
			}
			if(tempcoef.length() > 1 || str.length() <= 1) {
				double coef = Double.parseDouble(tempcoef);
				int pow = Integer.parseInt(temppow);
				Monom temp = new Monom(coef,pow);
				this.monomials.add(temp);
				tempcoef = "0";
				temppow = "0";
				if(i+1 != str.length() && (str.charAt(i) < 48 && str.charAt(i) > 57)) {
					while((str.charAt(i+1) < 48 || str.charAt(i+1) > 57)) {
						i++;
					}
				}

			}
		}
		Collections.sort(this.monomials, new Monom_Comperator());
		reducin(this.monomials);
		removeZero(this.monomials);
	}



	// METH
	// ***************** add your code below **********************

	/**
	 * This function will return this polynomial value at f(x).
	 */
	@Override
	public double f(double x) {
		double ans = 0;
		Iterator<Monom> itr = this.monomials.iterator();
		while(itr.hasNext()) {
			ans += itr.next().f(x);
		}
		return ans;
	}
	/**
	 * This Function will add polynomial p1 to this polynomial.
	 */
	@Override
	public void add(Polynom_able p1) {
		List<Monom> temp = new ArrayList<>();
		p1.iteretor().forEachRemaining(temp::add);
		Collections.sort(temp, new Monom_Comperator());
		reducin(temp);
		removeZero(temp);
		Iterator<Monom> itr = temp.iterator();
		while(itr.hasNext()) {
			this.monomials.add(itr.next());
		}
		Collections.sort(this.monomials, new Monom_Comperator());
		reducin(this.monomials);
		removeZero(this.monomials);
	}


	/**
	 * This function will add monom to this polynomial.
	 */
	@Override
	public void add(Monom m1) {
		this.monomials.add(m1);
		removeZero(this.monomials);
		Collections.sort(this.monomials, new Monom_Comperator());
		reducin(this.monomials);
		removeZero(this.monomials);
	}

	/**
	 * This function will subtract polynomial from this polynomial.
	 */
	@Override
	public void substract(Polynom_able p) {
		List<Monom> temp = new ArrayList<>();
		List<Monom> plist = new ArrayList<>();
		p.iteretor().forEachRemaining(plist::add);
		for(Monom mptemp : plist) {
			temp.add(new Monom(mptemp.get_coefficient()*(-1), mptemp.get_power()));
		}
		for(Monom mtemp : temp) {
			this.monomials.add(mtemp);
		}
		Collections.sort(this.monomials, new Monom_Comperator());
		reducin(this.monomials);
		removeZero(this.monomials);
	}

	/**
	 * This function will multiply polynomial with this polynomial.
	 */
	@Override
	public void multiply(Polynom_able p) {
		List<Monom> list = new ArrayList<>();
		List<Monom> plist = new ArrayList<>();
		p.iteretor().forEachRemaining(plist::add);
		for(Monom thismonom : this.monomials) {
			for(Monom pmonom : plist) {
				Monom mtemp = new Monom(thismonom.get_coefficient()*pmonom.get_coefficient(), thismonom.get_power()+pmonom.get_power());
				list.add(mtemp);
			}
		}
		Collections.sort(list, new Monom_Comperator());
		reducin(list);
		removeZero(list);
		this.monomials.clear();
		list.iterator().forEachRemaining(this.monomials::add);
		Collections.sort(this.monomials, new Monom_Comperator());
		reducin(this.monomials);
		removeZero(this.monomials);
	}

	/**
	 * This function will check if this polynomial is equal to another.
	 */
	@Override
	public boolean equals(Polynom_able p1) {
		Polynom p1temp = new Polynom((Polynom)p1);
		if(this.monomials.size() != p1temp.monomials.size()) {
			return false;
		}
		for (int i = 0; i < this.monomials.size() ; i++) {
			if((this.monomials.get(i).get_coefficient() != p1temp.monomials.get(i).get_coefficient()) || (this.monomials.get(i).get_power() != p1temp.monomials.get(i).get_power())) {
				return false;
			}
		}
		return true;
	}

	/**
	 * This function will check if the polynomial is empty.
	 */
	@Override
	public boolean isZero() {
		return monomials.isEmpty();
	}

	/**
	 * This function assuming (f(x0)*f(x1)<=0, returns f(x2) such that: (i) x0<=x2<=x2 & (ii) {f(x2)<eps .
	 */
	@Override
	public double root(double x0, double x1, double eps) {
		double x2 = x0;
		while(Math.abs(x1-x0) > eps) {
			x2 = (x1 + x0)/2;
			if(f(x1) * f(x2) > 0) 	x0 = x2;
			else	x1 = x2;
		}
		return x0;
	}

	/**
	 * This function creates a deep copy of this polynomial.
	 * @return 
	 */
	@Override
	public Polynom_able copy() {
		Polynom p = new Polynom();
		Iterator<Monom> itr = this.monomials.iterator();
		while(itr.hasNext()) {
			p.add(new Monom(itr.next()));
		}
		return p;
	}
	/**
	 * This function will return a copy of the derivative of this polynomial.
	 */
	@Override
	public Polynom_able derivative() {
		Polynom p = new Polynom(this);
		Iterator<Monom> itr = p.monomials.iterator();
		while (itr.hasNext()) {
			itr.next().derivative();
		}
		return p;
	}

	/**
	 * Compute Riemann's Integral over this Polynom starting from x0, till x1 using eps size steps,
	 * see: https://en.wikipedia.org/wiki/Riemann_integral
	 * @return the approximated area above the x-axis below this Polynom and between the [x0,x1] range.
	 */
	@Override
	public double area(double x0, double x1, double eps) {
		double width = (x1 - x0) / eps;
		double sum = 0.0;
		for (int i=0; i < eps; i++) {
			double first_mid_p=x0 + (width / 2.0) + i * width;
			sum = sum + (first_mid_p*2-first_mid_p+3);
		}
		return sum*width;
	}

	/**
	 * @return an Iterator (of Monoms) over this Polynom
	 * @return
	 */
	@Override
	public Iterator<Monom> iteretor() {
		return this.monomials.iterator();
	}

	/**
	 * This function will display the polynomial.
	 */
	public String toString() {
		String s = "F(X) = ";
		Iterator<Monom> itr = this.monomials.iterator();
		while(itr.hasNext()) {
			s += new Monom(itr.next()).toString();
			if(itr.hasNext()) s += "+";
		}
		return s;
	}

	//****************** Private Methods and Data *****************

	/**
	 * This function will receive a sorted List of monoms and combine common elements.
	 * @param list
	 */
	// only with sorted list and reducin monoms
	private void reducin(List<Monom> list) {
		int i = 1;
		while(i < list.size()){
			if(list.get(i).get_power() == list.get(i-1).get_power()) {
				list.get(i-1).add(list.get(i));
				list.remove(i);
				i--;
			}
			i++;
		}
	}

	/**
	 * This function will receive a sorted List of monoms and get rid of the zeros.
	 * @param list
	 */
	private void removeZero(List<Monom> list) {
		Iterator<Monom> itr = list.iterator();
		int counter = 0;
		boolean flag = true;
		while(itr.hasNext() && counter < list.size()) {
			if((list.get(counter).get_coefficient() == 0)) {
				list.remove(counter);
				flag = false;
			}
			if(flag == true) {
				counter++;
			}
			flag = true;
		}
	}


}
