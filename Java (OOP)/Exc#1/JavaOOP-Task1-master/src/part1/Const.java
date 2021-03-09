package part1;
import java.util.*;
import java.io.*;
/**
this class contains all the public constants
of the Ex2b tester
*/
class Const {
	
	public final static int MAX_X = 300;
	public final static int MAX_Y = 350;
	public static String APPLICATION_TITLE = "EX5 tester ", DATA_FILE = "a1.txt";

	//************************************************************************
	 public static void show(ShapeContainer sc) {
  		MyFrame win = new MyFrame();
  		for(int i=0;i<sc.R_size();i=i+1) win.add(sc.R_at(i));
  		for(int i=0;i<sc.T_size();i=i+1) win.add(sc.T_at(i));	
  		win.show();
  	}
	 public static ShapeContainer getSC() {
  		ShapeContainer ans = new ShapeContainer();	
       		try{
       			ans = loadFromFile(DATA_FILE);
       		}
       		catch(Exception e){     // in case something went wrong.
       			System.out.println("** Error while reading text file **"); 
       			System.out.println(e);
       			System.out.println("** giving up! **");
       		}
  		return ans;
  	}
	
	
	private static Point Point(String s) throws Exception {
		Point ans = null;
		StringTokenizer st = new StringTokenizer(s);
		st.nextToken();
		double x = (new Double(st.nextToken())).doubleValue();
		double y = (new Double(st.nextToken())).doubleValue();
		int c = (new Integer(st.nextToken())).intValue();
		ans = new Point(x,y);
		return ans;
	}
	private static Rectangle Rectangle(String s) throws Exception {
		Rectangle ans = null;
		StringTokenizer st = new StringTokenizer(s);
		st.nextToken();
		String s1 = st.nextToken()+" "+st.nextToken()+" "+st.nextToken()+" "+st.nextToken();
		String s2 = st.nextToken()+" "+st.nextToken()+" "+st.nextToken()+" "+st.nextToken();
		
		Point p1 = Point(s1);
		Point p2 = Point(s2);
		ans = new Rectangle(p1,p2);
		Boolean b = new Boolean(st.nextToken());
		return ans;
	}
	private static Triangle Triangle(String s) throws Exception {
		Triangle ans = null;
		StringTokenizer st = new StringTokenizer(s);
		st.nextToken();		
		String s1 = st.nextToken()+" "+st.nextToken()+" "+st.nextToken()+" "+st.nextToken();
		String s2 = st.nextToken()+" "+st.nextToken()+" "+st.nextToken()+" "+st.nextToken();
		String s3 = st.nextToken()+" "+st.nextToken()+" "+st.nextToken()+" "+st.nextToken();
		
		Point p1 = Point(s1);
		Point p2 = Point(s2);
		Point p3 = Point(s3);
		
		ans = new Triangle(p1,p2,p3);

		return ans;
	}
	

  	
  	private static ShapeContainer loadFromFile(String file) throws Exception {
		ShapeContainer ans = null;
    	FileReader fr = new FileReader(file);
    	BufferedReader is = new BufferedReader(fr);
		ans = new ShapeContainer();
		String line = is.readLine();
		while (line!=null) {
			StringTokenizer st = new StringTokenizer(line);
			String to = st.nextToken();
			if(to.equals("Rectangle")) ans.add(Rectangle(line));
			if(to.equals("Triangle")) ans.add(Triangle(line));
			line = is.readLine();
		}
		fr.close();
    return ans;
	}
	
	public static int s2i(String s) throws Exception {
        Integer i=new Integer(s);
        return i.intValue();
    }
    public static double s2d(String s) throws Exception {
        Double i=new Double(s);
        return i.doubleValue();
    }

}// const