#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>

int global = 6;

int main(int argc, char *argv[], char *envp[])
{
	int local = 10;
	pid_t pid;

	printf("before vfork\n");
	if((pid = vfork()) < 0)
		perror("vfork");
	else if(!pid) /* copil , pid == 0 */
	     {
		global++; local++;
		_exit(0);
	     }
	/* parinte */
	printf("child pid = %d, global = %d, local = %d\n", pid, global, local);
	exit(0);
}

/* Sample output
before vfork
child pid = 12220, global = 7, local = 11
*/


