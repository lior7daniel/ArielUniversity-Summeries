package Part_B;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * This class compares three running times of functions that perform
 * the same operations in different ways.
 * @author Lior Habani & Ilan Kitzio
 */
public class Ex3B {

	/**
	 * This function creates text files and writes a few random lines,
	 * then returns array with the names of the files.
	 * @param n 
	 * 		number of files.
	 * @return
	 * 		array with the names of the files.
	 */
	public static String[] createFiles(int n) {
		String[] fileNames = new String[n];
		String file_name = "";
		for (int i = 0; i < n; i++) {
			file_name = "File_" + i + ".txt";
			fileNames[i] = file_name;
			Random r = new Random(123);
			int numLines = r.nextInt(1000);
			BufferedWriter bw;
			try {
				bw = new BufferedWriter(new FileWriter(new File(file_name)));
				for (int j = 0; j < numLines; j++) {
					bw.write("Hello World!");
					bw.newLine();
				}
				bw.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return fileNames;
	}

	/**
	 * This function gets an array with file names and then deletes all of them.
	 * @param fileNames
	 * 		array with the names of the files.
	 */
	public static void deleteFiles(String[] fileNames) {
		for (int i = 0; i < fileNames.length; i++) {
			File file = new File(fileNames[i]);
			file.delete();
		}
	}

	/**
	 * This function creates files with a number of random lines 
	 * and checks the total number of rows by thread for each file.
	 * @param numFiles
	 * 		the number of files.
	 */
	public static void countLinesThreads(int numFiles) {
		System.out.println("*countLinesThreads*");
		String fileNames[] = createFiles(numFiles);
		LineCounter[] lc = new LineCounter[numFiles];
		int total_lines = 0;
		long time = System.currentTimeMillis();
		for (int i = 0; i < lc.length ; i++) {
			lc[i] = new LineCounter(fileNames[i]);
			lc[i].start();
			try {
				lc[i].join();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			total_lines += lc[i].getLines();
		}
		time = System.currentTimeMillis() - time;
		System.out.println("Total lines : " + total_lines);
		System.out.println("Time of threads work :" + time + "ms");
		deleteFiles(fileNames);
	}

	/**
	 * This function creates files with a number of random lines 
	 * and checks the total number of rows by pool thread for all the files.
	 * @param num
	 * 		the number of files.
	 */
	public static void countLinesThreadPool(int num) {
		System.out.println("*countLinesThreadPool*");
		String fileNames[] = createFiles(num);
		ExecutorService pool = Executors.newCachedThreadPool();
		List<Future<Integer>> all_lines = new ArrayList<Future<Integer>>();
		int total_lines = 0;
		long time = System.currentTimeMillis();
		for (int i = 0; i < num; i++) {
			Callable<Integer> tmp_lcc = new LineCounterCallable(fileNames[i]);
			Future<Integer> current = pool.submit(tmp_lcc);
			all_lines.add(current);
		}
		pool.shutdown();
		System.out.println("Waiting for all results...");
		for(Future<Integer> f : all_lines)
			try {
				total_lines += f.get();
			} catch (InterruptedException e) {
				e.printStackTrace();
			} catch (ExecutionException e) {
				e.printStackTrace();
			}
		time = System.currentTimeMillis() - time;
		System.out.println("Total lines : " + total_lines);
		System.out.println("Time of threads work :" + time + "ms");
		deleteFiles(fileNames);
	}

	/**
	 * This function creates files with a number of random lines 
	 * and checks the total number of rows by one process.
	 * @param numFiles
	 * 		the number of files.
	 */
	public static void countLinesOneProcess(int numFiles) {
		System.out.println("*countLinesOneProcess*");
		String fileNames[] = createFiles(numFiles);
		int total_lines = 0;
		long time = System.currentTimeMillis();
		for (int i = 0; i < fileNames.length; i++) {
			try (BufferedReader br = new BufferedReader(new FileReader(fileNames[i]))){
				while(br.readLine() != null) {
					total_lines++;
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		time = System.currentTimeMillis() - time;
		System.out.println("Total lines : " + total_lines);
		System.out.println("Time of threads work :" + time + "ms");
		deleteFiles(fileNames);
	}

	public static void main(String[] args) {
		int num = 1000;
		countLinesThreads(num);
		System.out.println();
		countLinesOneProcess(num);
		System.out.println();
		countLinesThreadPool(num);
	}
}

