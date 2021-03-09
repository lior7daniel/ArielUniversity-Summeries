/**
 * Solution to the task in the 'Algorithms 2' course.
 * 
 * This class represents an algorithm that finds the rectangular sub-matrix with the largest sum out of a triangle (or any shape that is not necessarily rectangular).
 * 
 * Thank you for the course!
 * 
 * @author Lior Daniel ( ID : 305257347 ) 
 *
 */
public class MaxSubRectangle {

	private final int MIN_INFINITY = Integer.MIN_VALUE;

	private int dataSize;
	private int[][] myData, myMat;

	private int rows, cols;

	private int maxSum;
	private int iLeft, iRight, jLeft, jRight;

	public MaxSubRectangle(int[][] data) {	
		myData = data;
		dataSize = myData.length;
		maxSum = MIN_INFINITY;
		iLeft = iRight = jLeft = jRight = -1;

		run();
	}

	private void run() {
		buildMat();
//		printMat();
		bestSubMatrix();
	}

	/**
	 * This function builds the matrix 'myMat' from the 'data' we received.
	 */
	private void buildMat() {
		// Check what should be the size of the mat.
		for (int i = 0; i < dataSize; i++) {
			if(rows < myData[i][0]) rows = myData[i][0];
			if(cols < myData[i][1]) cols = myData[i][1];
		}
		rows++; cols++;
		// Initialize every cell of the mat to minimum value.
		myMat = new int[rows][cols];
		for (int i = 0; i < rows; i++) {
			for (int j = 0; j < cols; j++) {
				myMat[i][j] = MIN_INFINITY;
			}
		}
		// Insert the specific values from the data.
		for (int k = 0; k < dataSize; k++) {
			myMat[myData[k][0]][myData[k][1]] = myData[k][2];
		}
	}

	/**
	 * This function calculate the maximum sum of shortest sub-array.
	 * @param a array of integers
	 * @return info sum -> [ sum , start index , end index ]
	 */
	public static int[] bestShortestArrCalc(int[] a) {

		int info[] = new int[3];
		int max = a[0], temp_max = 0, start = 0, end = 0, tmpStart = 0; 

		for (int i = 0; i < a.length; i++) { 
			temp_max += a[i]; 
			if (max < temp_max) { 
				max = temp_max; 
				start = tmpStart; 
				end = i; 			
			} 
			if(temp_max == max && i - tmpStart < end - start) {
				start = tmpStart;
				end = i;
			}
			if (temp_max < 0) { 
				temp_max = 0; 
				tmpStart = i + 1; 
			} 
		} 
		info[0] =  max; 
		info[1] =  start; 
		info[2] = end;
		return info;
	}

	/**
	 * 'Best' algorithm for matrix - the best rectangle with maximum sum
	 * Using BEST algorithm
	 * Complexity: O(n*m^2)
	 * @param matrix
	 * @return [max sum, first i_index, first j_index, last i_index, last j_index]
	 */
	private void bestSubMatrix() {
		int[][] help = new int[rows][cols+1];
		for (int i = 0; i < help.length; i++) {
			for (int j = 0; j < help.length; j++) {
				help[i][j] = MIN_INFINITY;
			}
		}
		for (int i = 0; i < rows; i++) {
			for (int j = 1; j < cols+1; j++) {
				if(myMat[i][j-1] == MIN_INFINITY && help[i][j] != MIN_INFINITY) help[i][j] = myMat[i][j-1];
				else if(help[i][j-1] == MIN_INFINITY) help[i][j] = myMat[i][j-1];
				else help[i][j] = help[i][j-1] + myMat[i][j-1];
			}
		}
		for (int i = 0; i < cols; i++) {
			for (int j = i; j < cols; j++) {
				int[] temp = new int[rows];
				for (int k = 0; k < rows; k++) {
					if(help[k][i] == MIN_INFINITY && help[k][j+1] == MIN_INFINITY) temp[k] = MIN_INFINITY; 
					else if(help[k][i] == MIN_INFINITY) temp[k] = help[k][j+1];
					else if(help[k][j+1] == MIN_INFINITY) temp[k] = help[k][j+1];
					else temp[k] = help[k][j+1] - help[k][i];
				}
				int[] best = bestShortestArrCalc(temp);
				if(best[0] > maxSum) {
					maxSum = best[0]; 
					iLeft = best[1];
					iRight = best[2];
					jLeft = i;
					jRight = j;
				}
			}
		}
	}

	/**
	 * This function prints the matrix. 
	 */
	public void printMat() {
		for (int i = 0; i < myMat[0].length; i++) {
			System.out.print("\t [" + i + "]");
		}
		System.out.println();
		for (int i = 0; i < myMat.length; i++) {
			System.out.println();
			System.out.println();
			System.out.print("[" + i + "] \t");
			for (int j = 0; j < myMat[i].length; j++) {
				if(myMat[i][j] == MIN_INFINITY) System.out.print("  Inf \t");
				else System.out.print("  " + myMat[i][j] + "\t");
			}
			System.out.println();
			System.out.println();
		}
	}

	public int getMaxSum() {
		return maxSum;
	}

	public int getILeft() {
		return iLeft;
	}

	public int getIRight() {
		return iRight;
	}

	public int getJLeft() {
		return jLeft;
	}

	public int getJRight() {
		return jRight;
	}

	public static void main(String[] args) {

		int data1[][] = {	
				{0	,3	,1	},
				{1	,2	,1	},
				{1	,3	,2	},
				{1	,4	,-4	},
				{2	,1	,2	},
				{2	,2	,-3 },
				{2	,3	,3	},
				{2	,4	,3	},
				{2	,5	,1	},
				{3	,0	,-2	},
				{3	,1	,10	},
				{3	,2	,9	},
				{3	,3	,-2	},
				{3	,4	,4	},
				{3	,5	,5	},
				{3	,6	,-11},
		};

		MaxSubRectangle test1 = new MaxSubRectangle(data1);
		System.out.println("Data #1 : maxSum = " + test1.getMaxSum() + ", iLeft = " + test1.getILeft() + ", jLeft = " + test1.getJLeft() + ", iRight = " + test1.getIRight() + ", jRight = " + test1.getJRight());

		int data2[][] = {	
				{1	,2	,20	},
				{2	,1	,-10},
				{2	,2	,21	},
				{2	,3	,2	},
				{2	,7	,8	},
				{3	,2	,3	},
				{3	,6	,7	},
				{3	,7	,9	},
				{3	,8	,10	},
				{4	,5	,6	},
				{4	,6	,-44},
				{4	,7	,5	},
				{4	,8	,7	},
				{4	,9	,11	},
				{5	,5	,5	},
				{5	,6	,10	},
				{5	,7	,33	},
				{5	,8	,-28},
				{5	,9	,7	},
				{6	,5	,4	},
				{6	,6	,13	},
				{6	,7	,-4	},
				{6	,8	,1	},
				{6	,9	,6	},
				{7	,5	,-10},
				{7	,6	,17	},
				{7	,7	,15	},
				{7	,8	,4	},
				{7	,9	,5	},
				{8	,5	,3	},
				{8	,6	,2	},
				{8	,7	,-60},
				{8	,8	,2	},
				{8	,9	,3	}
		};

		MaxSubRectangle test2 = new MaxSubRectangle(data2);
		System.out.println("Data #2 : maxSum = " + test2.getMaxSum() + ", iLeft = " + test2.getILeft() + ", jLeft = " + test2.getJLeft() + ", iRight = " + test2.getIRight() + ", jRight = " + test2.getJRight());
	}
}
