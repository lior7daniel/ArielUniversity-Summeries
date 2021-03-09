#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sched.h>

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
	
int main(int argc, char* argv[]) {
	
	// initialize PID.
	if(argc != 2){
		printf("Please put up pid number\n");
		printf("Example: ./a.out <pid>\n");
		printf("Client turned off!\n");
		return 1;
	}
	
	pid_t pid = atoi(argv[1]);
	
	int policyNumber, priorityNumber, ret;
	
	// initialize the struct that holds the priority.
	struct sched_param sp;	
	
	// read the priority of the given pid.
	policyNumber = sched_getscheduler(pid);
	printf("The policy of pid %d is: ", pid);
	printPolicyByNumber(policyNumber);
	
	// read to the struct (sp) the priority parameter of the given pid.
	ret = sched_getparam(pid, &sp);
	if (ret == -1) {
		perror("sched_setscheduler");
		return 1;
	}
	printf("The priority of %d pid is: %d\n", pid, sp.sched_priority);

	runInstructions(&pid, &policyNumber, &priorityNumber);

	sp.sched_priority = priorityNumber;
	
	ret = sched_setscheduler(pid, policyNumber, &sp);
		
	printf("AFTER CHANGES:\n");
	printf("policy: %d\n", policyNumber);
	printf("priority: %d\n", priorityNumber);

	return 0;
}