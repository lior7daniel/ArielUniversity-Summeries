package myMath;

import java.util.Comparator;

public class Monom_Comperator implements Comparator<Monom> {


	public int compare(Monom m1, Monom m2)
	{
		int ans = m2.get_power() - m1.get_power();
		return ans;
	}

}