package Part_A;
import java.util.Arrays;

/**
 * This class is used to find the elements larger than the median of two sorted arrays. 
 * @author Lior Habani & Ilan Kitzio
 *
 */
public class BigThanMedian {

	/**
	 * This function uses a thread for each iteration in an algorithm (*)
	 * to find the elements larger than the median. 
	 * @param a
	 * 		first sorted array.
	 * @param b
	 * 		second sorted array.
	 * @return
	 * 		array with the elements lager than the median.
	 */
	public static int[] bigThanMedianAlgo(int []a, int[] b){
		int size = a.length;
		int ans[] = new int[size];
		long time = System.currentTimeMillis();
		for (int i = 0; i < ans.length; i++) {
			bigThanMedianCalcThread temp = new bigThanMedianCalcThread(a[i], b[size-i-1]);
			temp.run();
			try {
				temp.join();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			ans[i] = temp.getMax();
		}
		time = System.currentTimeMillis() - time;
		Arrays.sort(ans);
		System.out.println("*bigThanMedianAlgo*");
		System.out.println("Time : " + time + "ms");
		System.out.println();
		return ans;
	}

	/**
	 * This function uses a merged and sorted array of the two arrays (a,b) 
	 * to find the elements larger than the median.
	 * @param a
	 * 		first sorted array.
	 * @param b
	 * 		second sorted array.
	 * @return
	 * 		array with the elements lager than the median.
	 */
	public static int[] bigThanMedianMerge(int[]a, int[] b) {
		int size = a.length;
		int merge[] = new int[2*size];
		int c[] = new int [size];
		int i = 0, j = 0, k = 0; 
		long time = System.currentTimeMillis();
		while (i<size && j <size){ 
			if (a[i] < b[j]) merge[k++] = a[i++]; 
			else merge[k++] = b[j++]; 
		} 
		while (i < size) merge[k++] = a[i++]; 
		while (j < size) merge[k++] = b[j++]; 

		for (int z = size; z < size*2; z++) {
			c[z-size] = merge[z];
		}
		time = System.currentTimeMillis() - time;
		System.out.println("*bigThanMedianMerge*");
		System.out.println("Time : " + time + "ms");
		System.out.println();
		return c;
	}

	/**
	 * This function returns an array with random numbers of the required size.
	 * @param size
	 * 		size of the array.
	 * @param begin_number
	 * 		The begin number from it will start to generate random numbers
	 * @param final_number
	 * 		The final number to which we will generate random numbers.
	 * @return
	 */
	public static int[] getRandomSortedArray(int size, int begin_number, int final_number) {
		int arr[] = new int[size];
		int num;
		for (int i = 0; i < arr.length; i++) {
			num = (int) ((Math.random()*final_number)+begin_number);
			arr[i] = num;
		}
		Arrays.sort(arr);
		return arr;
	}

}
