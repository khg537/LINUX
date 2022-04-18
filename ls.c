#include "ls.h"

int main(int argc, char **argv)
{
	for (int i = 0 ; i <argc -1 ; i++)
	{
		list_display(argv[i + 1]);
	}

	return 0;

}

