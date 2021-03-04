package Part_B;

import java.util.Arrays;
import java.util.Scanner;

/**
 * This class represents the Number's Game algorithm with two options of gameplay : student vs computer OR student vs student.
 * @author Lior Daniel and Ilan Kitzio.
 *
 */
public class NumbersGameComp {

	int []arr;
	int []tmp;

	/**
	 * This function returns an array with random numbers
	 * @param size
	 * 			size of the array
	 * @return
	 * 			array of integers
	 */
	private int[] getRandomArray(int size) {
		if(size%2 != 0) size++;
		int arr[] = new int[size];
		for (int i = 0; i < arr.length; i++) arr[i] = (int) ((Math.random()*20)+1);
		return arr;
	}

	/**
	 * This function starts the game vs the computer.
	 * @param size
	 * 			size of the array.
	 */
	public void playVSComputer(int size) {
		arr = getRandomArray(size);
		tmp = arr.clone();
		playVSComputer(arr);
	}

	/**
	 * This function starts the game vs the other student.
	 * @param size
	 * 			size of the array.
	 */
	public void studentVSstudent(int size) {
		arr = getRandomArray(size);
		tmp = arr.clone();
		studentVSstudent(arr);
	}

	/**
	 * the gameplay vs the computer.
	 * to choose the number in the left side of the array insert 0! other number to choose the right side!
	 * @param arr
	 * 			array.
	 */
	private void playVSComputer(int []arr){
		boolean even=true;
		int left=0, right=arr.length-1;
		int sumComputer=0,sumStudent=0, choice;
		int sumEven = 0, sumOdd = 0;
		Scanner s = new Scanner(System.in);
		for(int k=0; k<arr.length; k=k+2){
			sumEven = sumEven + arr[k];
			sumOdd = sumOdd + arr[k+1];
		}
		System.out.println("THIS IS A GAME:");
		System.out.println(Arrays.toString(arr));
		while(left < right){
			even=true;
			if (sumOdd > sumEven) even = false;
			else if (sumOdd == sumEven) {
				if(arr[left] > arr[right]) {
					if (left%2 == 0) even=true;
					else even = false;
				}
				else {
					if (right%2 == 0) even=true;
					else even = false;
				}
			}
			if (left%2==0){
				if (even) {
					sumComputer = sumComputer + arr[left];
					sumEven = sumEven-arr[left++];
				}
				else{
					sumComputer = sumComputer + arr[right];
					sumOdd = sumOdd - arr[right--];
				}
			}
			else{
				if (even){
					sumComputer = sumComputer + arr[right];
					sumEven = sumEven - arr[right--];
				}
				else{
					sumComputer = sumComputer + arr[left];
					sumOdd = sumOdd - arr[left++];
				}
			}
			System.out.println("SUM => Computer: "+sumComputer+", Student: "+sumStudent);
			this.tmp = Arrays.copyOfRange(arr, left, right+1);
			System.out.println(Arrays.toString(this.tmp));
			choice = s.nextInt();
			if (choice==0) {
				if (left%2 == 0) sumEven = sumEven - arr[left];
				else sumOdd = sumOdd - arr[left];
				sumStudent = sumStudent + arr[left++];			
			}
			else {
				if (right%2 == 0) sumEven = sumEven - arr[right];
				else sumOdd = sumOdd - arr[right];
				sumStudent = sumStudent + arr[right--];			
			}
		}
		System.out.println("SUM => Computer: "+sumComputer+", Student: "+sumStudent);
		System.out.println("COMPUTER WON!");
	}

	/**
	 * the gameplay vs the student.
	 * to choose the number in the left side of the array insert 0! other number to choose the right side!
	 * @param arr
	 */
	private void studentVSstudent(int []arr){
		int left=0, right=arr.length-1;
		int student1_sum=0,student2_sum=0, chooser_turn=1, choice;
		Scanner s = new Scanner(System.in);
		System.out.println("THIS IS A GAME:");
		System.out.println(Arrays.toString(arr));

		while(left <= right) {
			if(chooser_turn == 1) {
				System.out.println("student 1 turn!");
				choice = s.nextInt();
				if(choice == 0) student1_sum += arr[left++];
				else student1_sum += arr[right--];
				chooser_turn=2;
			}
			else {
				System.out.println("student 2 turn!");
				choice = s.nextInt();
				if(choice == 0) student2_sum += arr[left++];
				else student2_sum += arr[right--];
				chooser_turn=1;
			}
			System.out.println("SUM => student 1 : "+student1_sum+", student 2 : "+student2_sum);
			this.tmp = Arrays.copyOfRange(arr, left, right+1);
			System.out.println(Arrays.toString(this.tmp));
		}
		System.out.println("SUM => student 1 : "+student1_sum+", student 2 : "+student2_sum);
		if(student1_sum > student2_sum) System.out.println("student 1 WON!");
		else if(student1_sum > student2_sum) System.out.println("student 2 WON!");
		else System.out.println("EQUAL!");
	}
	
	public static void main(String[] args) {
		NumbersGameComp game = new NumbersGameComp();
		game.studentVSstudent(5);
	}
	
}









