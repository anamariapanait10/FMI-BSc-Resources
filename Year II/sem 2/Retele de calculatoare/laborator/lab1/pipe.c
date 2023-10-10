#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char *argv[])
{
           int fd[2], n;
           pid_t pid;
           char buf[80];

           if (pipe(fd) == -1) {
               perror("pipe");
               exit(1);
           }

           if ((pid = fork()) == -1) {
               perror("fork");
               exit(1);
           }

           if (!pid) {    /* Child reads from pipe */
               close(fd[1]);          /* Close unused write end */

               n = read(fd[0], buf, 80);
               write(1, buf, n);
               close(fd[0]);
               _exit(0);

           } else {            /* Parent writes to pipe */
               close(fd[0]);          /* Close unused read end */
               write(fd[1], "hello world\n", 12);
               close(fd[1]);          /* Reader will see EOF */
               wait(NULL);                /* Wait for child */
               exit(0);
           }
}
