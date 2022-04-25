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

#define LIST  1
#define INODE 2
#define RECUR  4
#define ALL   8

void  long_list_display(const char*, int);
void  short_list_display(const char*, int);
void  dir_search(const char*, int);
