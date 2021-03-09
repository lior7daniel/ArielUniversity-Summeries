#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <signal.h>
#include <sys/wait.h>

// ***************************************************************
// **************************** READ ME **************************
// ***************************************************************
// In this section, we created two father and son processes 
// that use Pipe communication to read and write to shared memory 
// and advance the Counter by 1 to 5.
// ***************************************************************

static int myPipe[2];
static int counter = 0;
static pid_t pid_child;
static pid_t pid_parent;
void parent_handlr(int sig_num);
void child_handlr(int sig_num);

int main(){
    if (pipe(myPipe) < 0){
        printf("Pipe Failed!\n");
        exit(1);
    }
    pid_t pid = fork();
    sleep(5);
    if (pid < 0){
        printf("Fork Failed!\n");
        exit(1);
    }
    pid_child = pid;
    pid_parent = getppid();

    if (pid == 0){
        signal(SIGUSR1, child_handlr);
        write(myPipe[1], &counter, sizeof(counter));
        kill(pid_parent, SIGUSR1);
        while (counter != 5){
            sleep(1);
            kill(pid_parent, SIGUSR1);
        }
    } else{
        signal(SIGUSR1, parent_handlr);
        while (counter != 5){
            sleep(1);
        }
        wait(0);
        printf("Parent is going to be terminated\n");
    }
    return 0;
}
void child_handlr(int sig_num){

    read(myPipe[0], &counter, sizeof(counter));

    printf("%d\n", counter);
    counter++;

	if(counter < 6){
		write(myPipe[1], &counter, sizeof(counter));
        kill(pid_parent, SIGUSR1);
	} else{
		printf("Child is going to be terminated\n");
        exit(0);
	}
}

void parent_handlr(int sig_num){
    read(myPipe[0], &counter, sizeof(counter));
    printf("%d\n", counter);
    counter++;
	if(counter < 6){
		write(myPipe[1], &counter, sizeof(counter));
        kill(pid_child, SIGUSR1);
	} else{
		close(myPipe[0]);
        close(myPipe[1]);
        return;
	}
}
