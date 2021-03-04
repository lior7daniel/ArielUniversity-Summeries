#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

int main(int argc, char* argv[]) {
	
	if(argc != 4){
		printf("Please put up 3 arguments: serverPID, signalNumber, numberOfSignalsToSend\n");
		printf("Client turned off!\n");
		return 1;
	}
	
	int serverPID = atoi(argv[1]);
	int signalNumber = atoi(argv[2]);
	int numberOfSignalsToSend = atoi(argv[3]);
	
	if( signalNumber == 2 ){
		for(int i = 0; i < numberOfSignalsToSend; i++){
			kill(serverPID, signalNumber);
		}
		printf("%d signals sent to pid %d\n", numberOfSignalsToSend, serverPID);
	}

	if( signalNumber == 10 ){
		kill(serverPID, signalNumber);
	}

	return 0;
}