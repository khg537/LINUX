#include "ls.h"

void  list_display(const char *fname)
{
	int i;

	struct stat buff;
	struct passwd *pwd;
	struct group *grp;

	char rwx[] = "rwx";
	char perm[11] = "----------";

	lstat(fname, &buff);

	if (S_ISDIR(buff.st_mode))       perm[0] = 'd';
	else if (S_ISCHR(buff.st_mode))  perm[0] = 'c';
	else if (S_ISBLK(buff.st_mode))  perm[0] = 'b';
	else if (S_ISFIFO(buff.st_mode)) perm[0] = 'p';
	else if (S_ISLNK(buff.st_mode))  perm[0] = 'l';
	else if (S_ISSOCK(buff.st_mode)) perm[0] = 's';

	int sbit[3] = {0,};
	for (int i = 0 ; i < 3 ; i++)
	{
		if ((buff.st_mode >> (11 -i)) & 0x1)
		{
			sbit[i] = 1;
		}
	}

	for (int i = 0 ; i < 9 ; i++)
	{
		if (  ( buff.st_mode >> ( 8 -i ) ) & 0x01 )
		{
			
			perm[i+1] = rwx[i%3]; 
		}

		if ((i%3 == 2))
		{
			if ((perm[i+1] == 'x') && sbit[i/3])
			{
				perm[i+1] = 's';
			}
			else if (sbit[i/3] && i/3 == 2) perm[i] = 'T';
			else if (sbit[i/3] && perm[i+1] == 'x') perm[i] = 's';
			else if (sbit[i/3]) perm[i+1] = 'S';
		}

	}

	printf("%s ", perm);
	printf("%ld ", buff.st_nlink);

	pwd = getpwuid(buff.st_uid);
	printf("%s ", pwd->pw_name);

    grp = getgrgid(buff.st_gid);
	printf("%s ", grp->gr_name);
	
	if (perm[0] =='c' || perm[0] == 'b')
		printf("%lu, %lu", (buff.st_rdev>>8)&0xff, buff.st_rdev&0xff );
	else
		printf("%lu ", buff.st_size);
	
	struct tm* tmp;
	tmp = localtime(&buff.st_mtime);
	printf("%2d월 %2d %02d:%02d ", tmp->tm_mon + 1, tmp->tm_mday, tmp->tm_hour, tmp->tm_min);

	if (perm[0] == 'l')
	{
		char buff[256];
		int ret = readlink(fname, buff, sizeof buff);
		buff[ret] = 0;
		
		printf("%s -> %s\n", fname, buff);

	}
	else
		printf("%s\n", fname);


}

