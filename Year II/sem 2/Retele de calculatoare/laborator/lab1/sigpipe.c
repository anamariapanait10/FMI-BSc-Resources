#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>

void (*old_handler)(int);

void handler(int signo)
{
	//printf("Caught signal no %d\n", signo);
	printf("Attempting to write in pipe raised a SIGPIPE\n");
}

int main(int argc, char *argv[])
{
           int fd[2], n;
           pid_t pid;
           char buf[80];

	   if((old_handler = signal(SIGPIPE, handler)) < 0)
		perror("signal"), exit(1);
	   if(old_handler == SIG_IGN)
		printf("parent: SIGPIPE is ignored by default\n");
           if (pipe(fd) == -1) {
               perror("pipe");
               exit(1);
           }

           if ((pid = fork()) == -1) {
               perror("fork");
               exit(1);
           }

           if (!pid) {    /* Child reads from pipe */
               /* close(fd[1]);           Close unused write end */

               n = read(fd[0], buf, 80);
	       write(1, "child received: ", 16);
               write(1, buf, n);
               close(fd[0]);
	       write(fd[1], "done\n", 5);
               _exit(0);

           } else {            /* Parent writes to pipe */
               close(fd[0]);           /* Close unused read end */
               write(fd[1], "hello world\n", 12);
               close(fd[1]);          /* Reader will see EOF */
               n = read(fd[0], buf, 80);
	       if(n < 0)
	       		perror("read error in parent");
	       write(1, "parent received: ", 17);
               write(1, buf, n);
               wait(NULL);                /* Wait for child */
               exit(0);
           }
}
