#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <syslog.h>

int main(){
	pid_t pid = fork();
	
	if(pid == 0){
		chdir("/");
		setsid();
		printf("starting my daemon\n");
		close(stdout);
		close(stdin);
		close(stderr);
		openlog("myDaemon", LOG_PID, LOG_DAEMON);
		syslog(LOG_NOTICE, "daemon started");
		sleep(3);
		syslog(LOG_NOTICE, "doing some work...");
		sleep(3);
		syslog(LOG_NOTICE, "daemon finished!");
	}
	else{
		printf("daemon PID %d\n", pid);
	}
	return 0;
}