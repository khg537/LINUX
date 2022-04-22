#include "ls.h"
#include <string.h>

int max_uname_w;
int max_grname_w;

int compare(const void *a, const void *b)
{
    return strcasecmp((char *)a, (char *)b);
}

int get_width(const char* p1, int  p2)
{
    int cnt = 0;

    while (p2)
    {
        p2/=10;
        cnt++;
    }

    if ((cnt == 0 ) && p1 != 0)
    {

        cnt = strlen(p1);
    }

    return cnt;
}

void long_list_display(const char* fname, int width, int flag)
{
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

    if (flag & INODE) printf("%ld ", buff.st_ino);

    printf("%s ", perm);
    printf("%ld ", buff.st_nlink);

    pwd = getpwuid(buff.st_uid);
    printf("%-*s ",max_uname_w, pwd->pw_name);

    grp = getgrgid(buff.st_gid);
    printf("%-*s ",max_grname_w,  grp->gr_name);

    if (perm[0] =='c' || perm[0] == 'b')
        printf("%lu, %lu ", (buff.st_rdev>>8)&0xff, buff.st_rdev&0xff );
    else
        printf("%*lu ",width, buff.st_size);

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

void short_list_display(const char* fname, int flag )
{
    struct stat buff;

    lstat(fname, &buff);

    if (flag&INODE)
    {
        printf("%ld  %s\t",buff.st_ino, fname);
    }
    else
        printf("%s\t", fname);
}

void dir_search(const char* dirname, int flag)
{
    DIR *dp;
    struct dirent *p;
    struct stat buff;
    int tot_blks = 0;
    int width = 0;
    int max_st_size = 0;

    int grname_w = 0;
    int uname_w = 0;

    struct passwd *pwd;
    struct group *grp;


    chdir(dirname);
    dp = opendir(".");

    if (flag & RECUR) printf("%s :\n",dirname);

    char dir_fname[1024][30];
    int n = 0;

    while (p = readdir( dp ))
    {
        if (!(flag & ALL) && (p->d_name[0] == '.'))
            continue;

        strcpy(dir_fname[n], p->d_name);

        lstat(p->d_name, &buff);

        pwd = getpwuid(buff.st_uid);
        uname_w =  get_width(pwd->pw_name, 0);

        max_uname_w = (max_uname_w < uname_w) ? uname_w : max_uname_w;

        grp = getgrgid(buff.st_gid);
        grname_w = get_width(grp->gr_name, 0);

        max_grname_w = (max_grname_w < grname_w)? grname_w : max_grname_w;

        tot_blks += buff.st_blocks;

        max_st_size = (  max_st_size < buff.st_size)? buff.st_size: max_st_size;
        n++;

    }

    qsort(dir_fname, n, sizeof(dir_fname[0]), compare);

//  for (int i = 0 ; i < n ; i ++)
//      printf("sort: %s\n", dir_fname[i]);


    width = get_width(NULL, max_st_size);

    rewinddir(dp);
    if (flag & LIST) printf("total  %d\n", tot_blks/2);

/*
    while (p = readdir( dp ))
    {
        if (!(flag & ALL) && (p->d_name[0] == '.'))
                continue;
        if (flag&LIST) long_list_display(p->d_name, width, flag);
        else short_list_display(p->d_name, flag);
    }
*/

    for (int i = 0 ; i < n ; i++)
    {
        if (flag&LIST) long_list_display(dir_fname[i], width, flag);
        else short_list_display(dir_fname[i], flag);
    }

    if (!(flag & LIST)) printf("\n");

    rewinddir(dp);

    while ((p = readdir( dp )) && (flag & RECUR))
    {
        lstat(p->d_name, &buff);

        if (S_ISDIR(buff.st_mode))
        {
            if (strcmp(p->d_name, ".") && strcmp(p->d_name, ".."))
            {
                    char namebuff[16] = "./";
                    printf("\n");
                    strcat(namebuff, p->d_name);
                    dir_search(namebuff, flag);
            }

        }
    }

    closedir(dp);
}
