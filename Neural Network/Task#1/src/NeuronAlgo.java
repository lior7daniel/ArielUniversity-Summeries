import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Scanner;
import java.util.Vector;

/**
 * This class represents training One Neuron to Classify the type of Iris.
 * @author Lior Daniel and Amir Adar
 *
 */
public class NeuronAlgo {

	int numOfUpdates;
	ArrayList<Vector<Double>> inputs;
	Vector<Integer> targets;
	Vector<Double> theta;

	/**
	 * Constructor that gets file name to build the program.
	 * @param fileName	
	 * 			the name of the text file.
	 */
	public NeuronAlgo(String fileName) {
		this.numOfUpdates 	= 0;
		this.inputs 		=	new ArrayList<Vector<Double>>();
		this.targets 		= 	new Vector<Integer>();
		this.theta 		= 	new Vector<Double>();
		for (int i = 0; i < 4; i++) {
			theta.add(0.0);
		}
		readFile(fileName);
	}
	
	/**
	 * Constructor that get file name and vector of weights.
	 * usually use for testing.
	 * @param fileName
	 * 			file name 
	 * @param theta
	 * 			vector of weights.
	 */
	public NeuronAlgo(String fileName, Vector<Double> theta) {
		this.numOfUpdates 	= 0;
		this.inputs 		=	new ArrayList<Vector<Double>>();
		this.targets 		= 	new Vector<Integer>();
		this.theta 			= 	theta;
		readFile(fileName);
	}

	/**
	 * This function reads the text file into list 
	 * and fills the input and target vectors.
	 * @param fileName
	 * 			file name
	 */
	public void readFile(String fileName) {
		Scanner s;
		ArrayList<String> list = new ArrayList<String>();
		try {
			s = new Scanner(new File(fileName));
			while (s.hasNext()){
				list.add(s.next());
			}
			s.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		Collections.shuffle(list);
		fillInputsAndTargets(list);
	}

	/**
	 * This function gets the list and calls to the function that fills
	 * the inputs and targets vectors line by line.
	 * @param list
	 * 			list of lines from the text file.
	 */
	public void fillInputsAndTargets(ArrayList<String> list) {
		for (int i = 0; i < list.size(); i++) {
			fillInputsAndTargets(list.get(i));
		}
	}
	/**
	 * This function fills the inputs and targets vectors from the line.
	 * @param line
	 * 			line that contains the inputs and the target.
	 */
	public void fillInputsAndTargets(String line) {
		String tmp = line;
		Vector<Double> inputVec = new Vector<Double>();
		while(line.indexOf(',') != -1) {
			if(tmp.equals("Iris-setosa") || tmp.equals("Iris-versicolor")) {
				if(tmp.equals("Iris-setosa")) this.targets.add(0);
				else this.targets.add(1);
				break;
			}
			else {
				inputVec.add(Double.parseDouble(tmp.substring(0, tmp.indexOf(','))));
				tmp = tmp.substring(tmp.indexOf(',')+1, tmp.length());	
			}
		}
		inputs.add(inputVec);
	}

	/**
	 * This function trains the the theta vector (vector of weights).
	 * @param X
	 * 			inputs vector.
	 * @param Y
	 * 			tartget vector.
	 */
	public void my_perceptron_train(ArrayList<Vector<Double>> X, Vector<Integer> Y) {
		int delta = 0;
		int numOfMistakes = 0;
		double lerningRate = 0.1;

		while(true) {
			for (int i = 0; i < X.size(); i++) {
				if(getDelta(X.get(i)) > 0.0) delta = 1;
				if(Y.get(i) != delta) {
					numOfUpdates++;
					numOfMistakes++;
					for (int j = 0; j < X.get(i).size(); j++) {
						theta.set(j, theta.get(j) + lerningRate * (Y.get(i) - delta) * X.get(i).get(j)) ;
						System.out.println(theta);
					}
				}
				delta = 0;
			}
			if(numOfMistakes == 0) break;
			numOfMistakes = 0;
		}
	}

	/**
	 * this function calculates the output.
	 * @param vec
	 * 			one input vector.
	 * @return
	 * 			double
	 */
	public double getDelta(Vector<Double> vec) {
		double ans = 0;
		for (int i = 0; i < vec.size(); i++) {
			ans += vec.get(i)*theta.get(i);
		}
		return ans;
	}

	/**
	 * This function gets inputs vector for testing according to given weight's vector.
	 * @param theta
	 * 			given weight's vector.
	 * @param x_test
	 * 			inputs vector for testing.
	 * @param y_test
	 * 			targets vector for testing.
	 * @return
	 * 		number of mistakes.
	 */
	public int my_perceptron_test(Vector<Double> theta, ArrayList<Vector<Double>> x_test, Vector<Integer> y_test) {
		int delta = 0;
		int numOfMistakes = 0;
		double lerningRate = 0.1;
		for (int i = 0; i < x_test.size(); i++) {
			if(getDelta(x_test.get(i)) > 0.0) delta = 1;
			if(y_test.get(i) != delta) {
				System.out.println(" mestake ");
				System.out.println(theta);
				numOfMistakes++;
			}
			delta = 0;
		}
		return numOfMistakes;
	}
	
	public static void main(String[] args) {
		NeuronAlgo app = new NeuronAlgo("iris.txt");
		app.my_perceptron_train(app.inputs, app.targets);
		System.err.println();
		System.err.println();
		System.err.println();
		System.err.println();
		System.err.println();
		NeuronAlgo app2 = new NeuronAlgo("irisTest.txt", app.theta);
		System.out.println(app2.my_perceptron_test(app.theta, app2.inputs, app2.targets));
	}
}
