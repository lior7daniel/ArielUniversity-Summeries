#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void sigintHandler();
void sigusr1Handler();

static int numOfSignals = 0;

int main(){
	
	signal(SIGINT, sigintHandler);
	signal(SIGUSR1, sigusr1Handler);
	
	printf("Listening...\n");
	while(1){
		sleep(1);
	}
	printf("Server turned off!\n");

	return 0;
}

void sigintHandler(){
	numOfSignals++;
}

void sigusr1Handler(){
	printf("I've received %d signals\n", numOfSignals);
}