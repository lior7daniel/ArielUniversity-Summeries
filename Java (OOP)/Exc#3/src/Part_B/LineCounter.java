package Part_B;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

/**
 * This thread calculates the number of lines in file.
 * @author Lior Habani & Ilan Kitzio.
 * 
 */
public class LineCounter extends Thread{

	private String name;
	private int lines;

	public LineCounter(String name) {
		this.name = name;
		this.lines = 0;
	}

	public void run() {
		try (BufferedReader br = new BufferedReader(new FileReader(name))){
			while(br.readLine() != null) {
				lines++;
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public int getLines() {
		return lines;
	}

	public String toString() {
		return "*Thread* " + this.name;
	}
}
