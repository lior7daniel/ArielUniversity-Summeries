#include<stdio.h> 
#include<stdlib.h> 
#include<unistd.h> 
#include<sys/types.h> 
#include<string.h> 
#include<sys/wait.h> 
#include <signal.h> 

    static int n=0;      
    static int b=1;      //boolean for know when n==5
    static int p;        //procces id
   static   int fd1[2];  //pipe

//signal handler stop when n==5
void handler(int sig) 
{               
    if(n>5) {
      b=0;
      }       
}

// function call read& wirte
     void foo(){
         static int x=0;            //son   n
         static int y=0;           //parent n
    if (p < 0) 
    { 
        fprintf(stderr, "fork Failed" ); 
        exit (1); 
    } 

    // child process 
    else if (p==0)
    {    
        write(fd1[1], &x, sizeof(x))  ;           // Write a val and close writing end 
        kill(getppid(),SIGUSR1)     ;         //send a SIGUSR1 to parent
        pause();                             // wait to a siganal from father
        read(fd1[0], &x, sizeof(x));        // Read a string using first pipe 
        printf("n = %d\n" ,x); 
         x++;                               //n++
        if(x==5) b=0;
       } 
  
    // Parent process 
    else   
    { 
        pause();                             // wait to a siganal from child
        read(fd1[0], &y, sizeof(y));         // Read a val from child, print it and close 
        printf("n = %d\n", y); 
        y++;                                  //n++
        write(fd1[1], &y, sizeof(y) );        // Write input string and close writing end of firs  pipe. 
        kill(0,SIGUSR1)   ;                   //send a SIGUSR1 to son       
        if(y==5) b=0;
    }
     }
    
      
int main() 
{ 
   signal(SIGUSR1, handler); //choosing signalhandler

    if (pipe(fd1)==-1) 
    { 
        fprintf(stderr, "Pipe Failed" ); 
        return 1; 
    } 
   
   p = fork(); 
   // incarse n and send 5 time with foo function
   while(b==1) {
        foo(); 
               }
        printf("end of pogram\n");
   return 0; 
} 
 

