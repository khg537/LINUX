#include "xls.h"

int multi_dir_flag;

FILEDESC file_desc[MAX_FILE_LIST_NUM];
FILEDESC dir_desc[MAX_DIR_LIST_NUM];


int main(int argc, char **argv)
{
	int ch;
	int flag = 0;

	int file_list_num = 0;
	int dir_list_num  = 0;
	int dir_disp_cnt  = 0;
	int opt_num		  = 0;	

	struct stat buff;

	while ( (ch = getopt(argc, argv, "liRa")) != -1)
	{
		switch (ch)
		{
			case 'l':
				flag |= LIST;
				break;

			case 'i':
				flag |= INODE;
				break;

			case 'R':
				flag |= RECUR;
				break;

			case 'a':
				flag |= ALL;
				break;
		}
	}


	if (flag > 0) opt_num =	1;

	if (argc == 1 + opt_num)
	{
		dir_display(".", flag);		
		exit(1);
	}
	

	for (int i = opt_num +1 ; i < argc  ; i++)
	{
		memset(&buff, 0, sizeof buff);
	    int err = stat(argv[i], &buff);
		if (!(err == 0))
		{
			printf("stat error!!!\n");
			exit(1);
		}
		

		if(S_ISDIR(buff.st_mode))
		{
			dir_desc[dir_list_num].is_dir = 1;

			dir_desc[dir_list_num].buff = buff;
			strcpy(dir_desc[dir_list_num].fname, argv[i]);
			
			dir_list_num++;
		}
		else 
		{
			file_desc[file_list_num].buff = buff;
			strcpy(file_desc[file_list_num].fname, argv[i]);

			file_list_num++;
		}

	}

	if (dir_list_num > 1) multi_dir_flag = 1;

	qsort(file_desc, file_list_num , sizeof(FILEDESC), compare_list_name);
	qsort(dir_desc, dir_list_num, sizeof(FILEDESC), compare_list_name);

	for (int i = 0 ; i < file_list_num   ; i++)
	{
		if (flag & LIST) long_list_display(file_desc[i].fname, flag );
		else short_list_display(file_desc[i].fname, flag );
	}
	
	if  (dir_list_num > 0 && file_list_num > 0)
	{
		if (flag & LIST) printf("\n");
		else printf("\n\n");
	}
	else if (file_list_num > 0 ) printf("\n");

	for (int i = 0 ; i <  dir_list_num ; i++)
	{
		dir_disp_cnt++;
		if (!(flag & RECUR)) printf("%s:\n", dir_desc[i].fname); 

		if (flag & LIST) dir_display(dir_desc[i].fname, flag );
		else dir_display(dir_desc[i].fname, flag );
			
		if (dir_disp_cnt < dir_list_num) printf("\n");

	}

	
	return 0;

}
