#define _XOPEN_SOURCE 500
#include <ftw.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define DEPTH_LIMIT  2

static int showInfo(const char *fpath, const struct stat *sb, int tflag, struct FTW *ftwbuf) {
   if (ftwbuf->level > DEPTH_LIMIT) {
       return 0; 
   }
   
	if(strcmp(fpath + ftwbuf->base,"sl")){
		printf("%-3s%ld %s \n", (tflag == FTW_D) ?   "D"   : (tflag == FTW_F) ?   "F" : "???", sb->st_ino, fpath + ftwbuf->base);
	}
	return 0;           
}

int main(int argc, char *argv[]) {
   int flags = 0;
   if (nftw((argc < 2) ? "." : argv[1], showInfo, 20, flags) == -1) {
       perror("nftw error");
       exit(EXIT_FAILURE);
   }
   exit(EXIT_SUCCESS);
}
