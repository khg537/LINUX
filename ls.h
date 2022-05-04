#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>
#include <dirent.h>
#include <stdlib.h>
#include <string.h>

#define LIST	1
#define INODE	2
#define RECUR	4
#define ALL		8

#define MAX_FILE_LIST_NUM 256 
#define MAX_DIR_LIST_NUM 256 

typedef struct
{
	struct stat buff;
	char fname[256];
	int  is_dir;
} FILEDESC;


void  long_list_display(const char*, int);
void  short_list_display(const char*, int);
void  dir_display(const char*, int);
int compare_list_name(const void *, const void *);
