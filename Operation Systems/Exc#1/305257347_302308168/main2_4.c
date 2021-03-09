#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <syslog.h>
#define _GNU_SOURCE
#include <sched.h>

#define STACK_SIZE 10000
#define CYCLES 20

char child_stack[STACK_SIZE+1];								// Task2

void print(const char* str){								// Task1
	for(int i = 0; i < 20; i++){							// Task1
	printf("This is : %s round %d \n", str, i);				// Task1	
	sleep(1);												// Task1
	}														// Task1	
}															// Task1
		
int child(void *params){									// Task2
	print("child_thread");									// Task2
}															// Task2

	
int main(){

	pid_t pid = fork();
	
	int result = clone(child, child_stack+STACK_SIZE, 0, 0);// Task2
	printf("clone result = %d \n", result);					// Task2
	print("parent");										// Task2
	
	if(pid == 0){
		
			print("grand child");							// Task1
			
			chdir("/");										// Task3
			setsid();										// Task3	
			printf("starting my daemon\n");					// Task3
			close(stdout);									// Task3
			close(stdin);									// Task3	
			close(stderr);									// Task3	
			openlog("myDaemon", LOG_PID, LOG_DAEMON);		// Task3
			syslog(LOG_NOTICE, "daemon started");			// Task3	
			sleep(3);										// Task3
			syslog(LOG_NOTICE, "doing some work...");		// Task3
			sleep(3);										// Task3	
			syslog(LOG_NOTICE, "daemon finished!");			// Task3
			
			//char * args[2] = {"./friend", NULL};
			//execvp(args[0], args);
	}
	else{
		print("parent");									// Task1
		printf("daemon PID %d\n", pid);						// Task3

	}
	
	return 0;
}