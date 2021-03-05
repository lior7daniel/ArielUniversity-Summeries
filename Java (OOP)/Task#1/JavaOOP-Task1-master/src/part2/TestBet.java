package part2;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;


public class TestBet {

	public static void readFile (String fileName){
		int numOfWords = 0;
		String mostRepeatedWord = "";
		Boolean firstRepeatedWordFlag = true;
		String longestWord = "";
		FileInputStream fis = null;
		DataInputStream dis = null;
		BufferedReader br = null;
		Map<String, Integer> wordMap = new HashMap<String, Integer>();
		try {
			fis = new FileInputStream(fileName);
			dis = new DataInputStream(fis);
			br = new BufferedReader(new InputStreamReader(dis));
			String line = null;
			while((line = br.readLine()) != null){
				StringTokenizer st = new StringTokenizer(line, " /-().;:,");
				while(st.hasMoreTokens()){
					String tmp = st.nextToken();
					numOfWords++;
					if(wordMap.containsKey(tmp)){
						wordMap.put(tmp, wordMap.get(tmp)+1);
					} else {
						wordMap.put(tmp, 1);
					}
					if(firstRepeatedWordFlag) {
						mostRepeatedWord = tmp;
						firstRepeatedWordFlag = false;
					}
					if(wordMap.get(tmp) > wordMap.get(mostRepeatedWord)) {
						mostRepeatedWord = tmp;
					}
					if(tmp.length() > longestWord.length()) longestWord = tmp;
					
				}
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally{
			try{if(br != null) br.close();}catch(Exception ex){}
		}
		System.out.println("\"" + fileName + "\"");
		System.out.println("	The Number of Different Words: " + wordMap.size());
		System.out.println("	The Number of Words: " + numOfWords);
		System.out.println("	The Most Frequent Word: (" + mostRepeatedWord +"), frequenncy: " + wordMap.get(mostRepeatedWord));
		System.out.println("	The Longest Word: (" + longestWord + ")");
	}
	



	public static void main(String[] args) {
		TestBet.readFile("text3.txt");
		TestBet.readFile("text1.txt");
	}

}
