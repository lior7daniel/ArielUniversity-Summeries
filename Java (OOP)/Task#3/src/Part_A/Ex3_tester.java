package Part_A;

public class Ex3_tester {
	/** This class represents a basic implementation for Ex3testing file. */
	public static double ENDLESS_LOOP=0.4;
	public static void main(String[]args){
		Ex3_tester ex3a=new Ex3_tester();
		long n=33333331;
		boolean ans = ex3a.isPrime(n,0.01);
		System.out.println("n="+n+" isPrime "+ans);
	}

	/**
	 * DONOT change this function!,it must be used
	 * byEx3A-isPrime(long,double)
	 * @param n
	 * 		n
	 * @return
	 * 		boolean
	 */
	public static boolean isPrime(long n){
		boolean ans=true;
		if(n<2)throw new RuntimeException("ERR: the parameter to the isPrime function must be > 1 (got "+n+")!");
		int i=2;
		double ns=Math.sqrt(n) ;
		while(i<=ns&&ans){
			if (n%i==0) ans=false;
			i=i+1;
		}
		if(Math.random()<Ex3_tester.ENDLESS_LOOP)while(true);
		return ans;
	}

	public boolean isPrime(long n, double maxTime) throws RuntimeException {
		long my_max_time = maxTimeToDateClassTime(maxTime);
		Timer timer = new Timer(my_max_time);
		timer.start();
		boolean done = isPrime(n);
		timer.stop();
		return done;	
	}

	/**
	 * This function converts seconds (double) to milliseconds (long).
	 * @param maxTime
	 * 		maxTime
	 * @return
	 * 		long
	 */
	public long maxTimeToDateClassTime(double maxTime) {
		long seconds = (long)maxTime;
		long milli = (long)((maxTime - seconds) * 1000);
		seconds *= 1000;
		return seconds + milli;
	}

	/**
	 * This thread inner class represents a timer that goes to sleep for 'maxTime' seconds.
	 * If the timer wakes up before it is destroyed, it will throw an error "TIME OUT".
	 * @author Lior Habani & Ilan Kitzin
	 *
	 */
	public class Timer extends Thread{

		private long max_time;

		public Timer(long max_time) {
			this.max_time = max_time;
		}

		public void run() {
			try {
				Thread.sleep(max_time);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			throw new RuntimeException("TIME OUT");
		}
	}
}
