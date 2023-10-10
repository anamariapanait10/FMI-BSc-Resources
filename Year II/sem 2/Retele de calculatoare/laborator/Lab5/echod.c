/* TCPechod.c - main, TCPechod */

#include <sys/types.h>
#include <sys/signal.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <sys/errno.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define QLEN 5
#define BUFSIZE 4096 /* maximum connection queue length */

extern int errno;
void reaper(int);
int TCPechod(int fd);
int passiveTCP(const char *service, int qlen);

/*------------------------------------------------------------------------
* main - Concurrent TCP server for ECHO service
*------------------------------------------------------------------------
*/
int main(int argc, char *argv[])
{
	char *service = "echo"; /* service name or port number */
	struct sockaddr_in fsin; /* the address of a client */
	int alen; /* length of client's address */
	int msock; /* master server socket */
	int ssock; /* slave server socket */

	switch (argc) {
		case 1:
			break;
		case 2:
			service = argv[1];
			break;
		default:
			printf("usage: TCPechod [port]\n"), exit(1);
	}

	msock = passiveTCP(service, QLEN);

	(void) signal(SIGCHLD, reaper);

	while (1) {
		alen = sizeof(fsin);
		ssock = accept(msock, (struct sockaddr *)&fsin, &alen);
		if (ssock < 0) {
			if (errno == EINTR)
				continue;
			printf("accept: %s\n", strerror(errno)), exit(1);
		}

		switch (fork()) {
			case 0:
				/* child */
				(void) close(msock);
				exit(TCPechod(ssock));
			default:
				/* parent */
				(void) close(ssock);
				break;
		case -1:
			printf("fork: %s\n", strerror(errno)), exit(1);
		}
	}
}

/*------------------------------------------------------------------------
* TCPechod - echo data until end of file
*------------------------------------------------------------------------
*/
int TCPechod(int fd)
{
	char buf[BUFSIZ];
	int cc;
	
	while (cc = read(fd, buf, sizeof buf)) {
		if (cc < 0)
			printf("echo read: %s\n", strerror(errno)), exit(1);
		if (write(fd, buf, cc) < 0)
			printf("echo write: %s\n", strerror(errno)), exit(1);
	}
	return 0;
}

/*------------------------------------------------------------------------
* reaper - clean up zombie children
*------------------------------------------------------------------------
*/
void reaper(int sig)
{
	int status;

	while (wait3(&status, WNOHANG, (struct rusage *)0) >= 0)
		/* empty */;
}

