#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sched.h>

// Hi, The following functions are not used but have been used for me to help solve the problem:
// 	1) checkPolicyByPID
// 	2) runInstructions
// 	3) printPolicyByNumber
// So please ignore them and refer only to the 'main' function, Thanks!

void checkPolicyByPID(int ipid);
void runInstructions(int *pid, int *policyNumber, int *priorityNumber);
void printPolicyByNumber(int policy);



int main(int argc, char* argv[]) {

	if(argc != 3){
		printf("Please put up 2 arguments to the ./a.out line: <policy> <priority>\n");
		printf("Example: ./a.out <policy> <priority>\n");
		printf("Client turned off!\n");
		return 1;
	}
	
	int policyNumber = atoi(argv[1]);
	int priorityNumber = atoi(argv[2]);
	
	int pid = getpid();
	printf("pid: %d \n\n", getpid());
	
	// read the current priority of the process.
	struct sched_param sp;
	sched_getparam(pid, &sp);
	printf("current priority: %d\n", sp.sched_priority);
	
	// read the current policy of the process
	int currentPolicyNumber = sched_getscheduler(pid);
	printf("current policy: %d - ", currentPolicyNumber);
	printPolicyByNumber(currentPolicyNumber);
	
	// initialize the struct that holds the priority with the given priority.
	sp.sched_priority = priorityNumber;	
	
	// set the given policy and priority to the process.
	int ret = sched_setscheduler(0, policyNumber, &sp);
	
	if (ret == -1) {
		perror("sched_setscheduler");
		return 1;
	}
	
	printf("\nCHANGES SUCCESSFULL!!!\n\n");
	printf("current priority: %d\n", sp.sched_priority);
	
	// read the current policy of the process
	currentPolicyNumber = sched_getscheduler(pid);
	printf("current policy: %d - ", currentPolicyNumber);
	printPolicyByNumber(currentPolicyNumber);

	
	return 0;
}






void checkPolicyByPID(int ipid){
	int policy;

	policy = sched_getscheduler(ipid);

	switch(policy) {
		case SCHED_OTHER: 	printf("SCHED_OTHER\n"); break;
		case SCHED_RR	:   printf("SCHED_RR\n"); break;
		case SCHED_FIFO	:  	printf("SCHED_FIFO\n"); break;
		default:   printf("Unknown...\n");
	}
}

void runInstructions(int *pid, int *policyNumber, int *priorityNumber){
	printf("Please enter a policy number accordingly:\n\n");
	printf("\t0\t->\tSCHED_OTHER\n");
	printf("\t1\t->\tSCHED_FIFO\n");
	printf("\t2\t->\tSCHED_RR \n");
	//printf("\t5 -> SCHED_IDLE\n");
	scanf("%d", policyNumber);
	
	int minPriority = sched_get_priority_min(*policyNumber);
	int maxPriority = sched_get_priority_max(*policyNumber);

	printf("Please enter a valid priority between %d - %d\n", minPriority, maxPriority);
	scanf("%d", priorityNumber);

}
	
void printPolicyByNumber(int policy){
	switch(policy) {
		case SCHED_OTHER: 	printf("SCHED_OTHER\n"); break;
		case SCHED_RR	:   printf("SCHED_RR\n"); break;
		case SCHED_FIFO	:  	printf("SCHED_FIFO\n"); break;
		default:			printf("Unknown...\n");
	}
}	