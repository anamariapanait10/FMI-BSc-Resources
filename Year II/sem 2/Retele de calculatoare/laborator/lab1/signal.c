#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>

void handler(int);

int main(int argc, char *argv[], char *envp[])
{
	pid_t pid;
	void (*old_handler)(int);

	if((old_handler = signal(SIGCHLD, handler)) == SIG_ERR)
		perror("signal"),exit(1);

	if((pid = fork()) == -1)
		perror("fork"), exit(1);

	if(pid)
		printf("press any key: \n\n"), getchar(), printf("done\n");
	else
	{
		/* pid == 0 */
		printf("child pid %d, parent pid %d\n", getpid(),getppid());
		exit(44);
	}
	exit(0);
}

void handler(int signal_number)
{
	pid_t pid;
	int status;

	printf("caught signal %d\n", signal_number);
	if((pid = waitpid((pid_t)0, &status, WNOHANG)) == -1)
	{
		printf(stderr, "SIGCHLD, but no one to wait for\n");
		return;
	}
	printf("child %d exits with status %d\n", pid, WEXITSTATUS(status));
}
