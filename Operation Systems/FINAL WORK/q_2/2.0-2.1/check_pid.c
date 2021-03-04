#include <sys/types.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>

void isExists(int pid){
		
	int rc = kill(pid, 0);
	
	if (rc != 0) {
		switch (errno) {
			case EINVAL:	// 22
				printf("An invalid signal was specified.\n");
				break;
				
			case EPERM:		// 1
				printf("The process does not have permission to send the signal to any of the target processes.\n");
				break;
			
			case ESRCH:		// 3
				printf("The pid or process group does not exist.\n");
				break;
		}	
	}
	else {
		printf("Exists!\n");
	}

}

int main(int argc, char* argv[]) {
	
	if(argc != 2){
		printf("Please put up the PIDnumber argument\n");
		printf("Client turned off!\n");
		return 1;
	}
	
	int pid = atoi(argv[1]);	
	isExists(pid);
	

	return 0;
	
}