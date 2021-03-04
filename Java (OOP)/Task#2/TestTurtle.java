package matala2A;

import Turtle.*;
class TestTurtle{
	
	public static void main (String [] args){
		SimpleTurtle bob = new SimpleTurtle();
		
		bob.tailDown();
		bob.moveForward(100);
		bob.turnRight(60);
		bob.moveForward(200);
	}
}