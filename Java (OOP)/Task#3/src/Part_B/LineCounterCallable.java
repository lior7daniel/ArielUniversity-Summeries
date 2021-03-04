package Part_B;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.concurrent.Callable;

/**
 * This class represent callable thread that returns the number the lines in file.
 * @author Lior Habani & Ilan Kitzio.
 *
 */
public class LineCounterCallable implements Callable<Integer>{

	private String name;
	private int lines;

	public LineCounterCallable(String name) {
		this.name = name;
		this.lines = 0;
	}
	
	@Override
	public Integer call() throws Exception {
		try (BufferedReader br = new BufferedReader(new FileReader(name))){
			while(br.readLine() != null) {
				this.lines++;
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return this.lines;
	}

	public String toString() {
		return "*Thread (Callable)* " + this.name;
	}
	
}
