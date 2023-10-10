#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include <signal.h>

int p1[2], p2[2];
int c = 'a';

int main(int argc, char *argv[], char *envp[])
{
	pid_t pid;

	if(pipe(p1) < 0 || pipe(p2) < 0)
		perror("pipe"), exit(1);
	if((pid = vfork()) < 0)
		perror("fork");
	else if(!pid)
	     {
		write(p1[1], &c, 1);
		read(p2[0], &c, 1);
		printf("pid = %d, c = %c\n", pid, c);
		_exit(0);
	     }
	read(p1[0], &c, 1);
	write(p2[1], "b", 1);
	printf("pid = %d, c = %c\n", pid, c);
}
