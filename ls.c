#include "ls.h"

int main(int argc, char **argv)
{
	int ch;
	int flag = 0;
	int opt_num = 0; 

	while ( (ch = getopt(argc, argv, "liRa")) != -1)
	{
		switch (ch)
		{
			case 'l':
				opt_num++;
				flag |= LIST;
				break;

			case 'i':
				opt_num++;
				flag |= INODE;
				break;

			case 'R':
				opt_num++;
				flag |= RECUR;
				break;

			case 'a':
				opt_num++;
				flag |= ALL;
				break;

		}
	}

	
	if (argc <= 1 + opt_num)
	{
		dir_search(".", flag);		
		exit(1);
	}

	for (int i = 0 ; i < argc -1 - opt_num ; i++)
	{
		if (flag & LIST) long_list_display(argv[1 + opt_num + i ],0, flag );
		else short_list_display(argv[1 + opt_num + i ], flag );
	}
	
	if (!(flag & LIST)) printf("\n");
	return 0;

}
