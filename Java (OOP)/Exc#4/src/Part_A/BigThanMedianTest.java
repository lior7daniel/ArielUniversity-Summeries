package Part_A;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Arrays;

import org.junit.jupiter.api.Test;

/**
 * Unit testing for BigThanMedian class.
 * @author Lior Habani & Ilan Kitzio
 *
 */
class BigThanMedianTest {

	@Test
	void test() {
		
		int a[] = BigThanMedian.getRandomSortedArray(100000, 1, 100);
		int b[] = BigThanMedian.getRandomSortedArray(100000, 1, 100);
		
		int algo[] = BigThanMedian.bigThanMedianAlgo(a, b);
		int merge[] = BigThanMedian.bigThanMedianMerge(a, b);
		
		boolean ans = Arrays.equals(algo, merge);
		
		assertEquals(true, ans);
	}

}
