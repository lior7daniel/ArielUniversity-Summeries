import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This program allows access to the AirportDB database.
 * @author Lior Daniel and Israel Buskila.
 *
 */
public class Connector {

	private Connection con;
	private Statement st;
	private ResultSet rs;

	/**
	 * This function initializes the connection with the AirportDB database 
	 * and allows the user to request queries.
	 */
	public void setConnection() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			System.out.println("Loading Driver...");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/AirportDB?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC","root","12345");
			System.out.println("Connected!");
			st=con.createStatement();
			rs = null;
			matalaPartASolution();
			rs.close();
			con.close();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}

	/**
	 * This function allows the user to enter the query request from the database.
	 */
	public void matalaPartASolution() {
		Scanner input = new Scanner(System.in);
		System.out.println("Please, enter a query request here!");
		if(input.hasNextInt()){
			System.out.println(Q3(input.nextInt()));
		}
		else if(input.hasNext()){
			switch(input.nextLine()) {
			case "Flights":
				System.out.println(Q1());
				break;
			case "flights":
				System.out.println(Q1());
				break;
			case "Airports":
				System.out.println(Q4());
				break;
			case "airports":
				System.out.println(Q4());
				break;
			default:
				System.out.println("Invalid input!");
			}
		}
		input.close();
	}

	/**
	 * Answer to question 1, In response to user input : "flights".
	 * This function shows in the console all the flight numbers that depart today,
	 * where they arrive and the flight hours.
	 * @return string.
	 */
	public String Q1() {
		String flights = " ";
		try {
			rs=st.executeQuery("select flight_no,TIMEDIFF(arr_time, dep_time), arr_loc from flights where dep_date = CURDATE()");
			flights = "|  " + rs.getMetaData().getColumnName(1) + "	|	" + rs.getMetaData().getColumnName(2) + "	|	" + rs.getMetaData().getColumnName(3) + "\n";
			while(rs.next()) {  
				flights = flights + "\n" + "|   " + rs.getInt(1) + "		|		" + rs.getString(2) + "		|	" + rs.getString(3);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		return flights;
	}

	/**
	 * Answer to question 3, In response to user input included only digits.
	 * This function displays in the console the number of flights in the last year of a passenger
	 * according to his / her ID.
	 * @param id - passenger id.
	 * @return string.
	 */
	public String Q3(int id) {
		String num_of_flights = " ";
		try {
			rs=st.executeQuery("call lastYearFlights(" + id + ", @num);");
			rs.next();
			switch(rs.getInt(1)) {
			case 0:
				num_of_flights = "Passenger ID " + id + " : NO flights in the past year!";
				break;
			default:
				num_of_flights = "Passenger ID " + id + " : had " + rs.getInt(1) + " flights in the past year!";
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return num_of_flights;
	}

	/**
	 * Answer to question 4, In response to user input : "airports".
	 * This function will show in JSON configuration,
	 * all the airports that can be reached from Ben-Gurion, flight number, date and arrival time.
	 * @return string.
	 */
	public JSONObject Q4() { 

		JSONArray array = new JSONArray();
		JSONObject obj = new JSONObject();
		JSONObject tmp_obj;

		try {
			rs=st.executeQuery("select flight_no, arr_loc, arr_date, arr_time from flights where dep_loc = \"Ben-Gurion\"");
			while (rs.next()) {
				tmp_obj = new JSONObject();
				tmp_obj.put("flight number", rs.getInt("flight_no"));
				tmp_obj.put("arrive location", rs.getString("arr_loc"));
				tmp_obj.put("arrive date", rs.getString("arr_date"));
				tmp_obj.put("arrive time", rs.getString("arr_time"));
				array.put(tmp_obj);
			}
			obj.put("flights", array);
		} catch (SQLException | JSONException e) {
			e.printStackTrace();
		}
		return obj;
	}

	
	public static void main(String[] args) {
		new Connector().setConnection();
	}


}
