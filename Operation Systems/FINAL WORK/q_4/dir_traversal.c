#define _XOPEN_SOURCE 500
#define MAX_DEPTH  2

#include <ftw.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>


static int fn(const char *dirpath, const struct stat *sb, int tflag, struct FTW *ftwbuf) {
	if (ftwbuf->level > MAX_DEPTH) {
		return 0; 
	}
   
	if(strcmp(dirpath + ftwbuf->base,"sl")){
		printf("%-3s%ld %s \n", (tflag == FTW_D) ?   "D"   : (tflag == FTW_F) ?   "F" : "???", sb -> st_ino, dirpath + ftwbuf->base);
	}
	return 0;           
}

int main(int argc, char *argv[]){
   int flags = 0;

   if (nftw((argc < 2) ? "." : argv[1], fn, 20, flags) == -1) {
       perror("NFTW ERROR!");
       exit(EXIT_FAILURE);
   }
   exit(EXIT_SUCCESS);
}
