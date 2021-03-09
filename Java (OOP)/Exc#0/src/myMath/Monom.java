package myMath;


/**
 * This class represents a simple "Monom" of shape a*x^b, where a is a real number and a is an integer (summed a none negative), 
 * see: https://en.wikipedia.org/wiki/Monomial 
 * The class implements function and support simple operations as: construction, value at x, derivative, add and multiply. 
 * @author Lior Daniel
 *
 */
public class Monom implements function{

	// VARS
	private double _coefficient; // 
	private int _power; 

	// CONST
	/**
	 * This constructor will create a new monomial equal to zero.
	 */
	public Monom() {
		this._coefficient = 0;
		this._power = 1;
	}

	/** 
	 * This constructor will create a new monomial with given coefficient and power.
	 * @param a
	 * @param b
	 */
	public Monom(double a, int b){
		if(b < 0) {
			throw new IllegalArgumentException("Error: b<0"); 
		}
		this.set_coefficient(a);
		this.set_power(b);
	}

	/**
	 * This constructor will create a new monomial that is a copy of another.
	 * @param m
	 */
	public Monom(Monom m) {
		this(m.get_coefficient(), m.get_power());
	}

	/**
	 * This function will set a new coefficient.
	 * @param a
	 */
	public void set_coefficient(double a){
		this._coefficient = a;
	}

	/**
	 * This function will set a new power.
	 * @param p
	 */
	public void set_power(int p) {
		this._power = p;
	}

	/**
	 * This function will return the coefficient of this monomial.
	 * @return
	 */
	public double get_coefficient() {
		return this._coefficient;
	}

	/**
	 * This function will return the power of this monomial.
	 * @return
	 */
	public int get_power() {
		return this._power;
	}

	/**
	 * This function will return this monomial value at 'x'.
	 */
	@Override
	public double f(double x) {
		return (this._coefficient*(Math.pow(x, _power)));
	}

	/**
	 * This function will add monomial 'm' to this monomial.
	 * @param m
	 * @return
	 */
	public Monom add(Monom m) {
		if(this.get_coefficient() == 0) {
			this._coefficient = m.get_coefficient();
			this._power = m.get_power();
		}
		else if(this.get_power() != m.get_power()) {
			throw new IllegalArgumentException("Exponents must match in order to add");
		}
		this._coefficient += m._coefficient;
		return this;
	}

	/**
	 * This function multiply this monomial with another monomial 'm'.
	 * @param m
	 * @return
	 */
	public Monom multiply(Monom m) {
		this._coefficient *= m._coefficient;
		this._power += m._power;
		return this;
	}

	/**
	 * This function will change this monomial to its derivative.
	 */
	public void derivative() {
		if(this._power==0) {
			this._coefficient = 0.0;
			this._power = 0;
		}
		else if(this._power==1) {
			this._power = 0;
		}
		else {
			this._coefficient = this._coefficient*this._power;
			this._power--;
		}
	}

	/**
	 * This Function will display the monomial.
	 */
	@Override
	public String toString() {
		return _coefficient+"x^" + _power;
	}


	//****************** Private Methods and Data *****************




}
