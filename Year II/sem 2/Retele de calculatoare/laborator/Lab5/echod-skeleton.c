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

	// create passive TCP socket

	// catch SIGCHLD signal

	while (1) {

		// accept incoming connection requests
		
		// fork
		// if child process, close master server socket and handle
		// the request over the slave connection
		// else if parent, close the slave server socket
		
	}
}


int TCPechod(int fd)
{
	// echo data until end of file
	return 0;
}

/*------------------------------------------------------------------------
* reaper - clean up zombie children
*------------------------------------------------------------------------
*/
{
// SIGCHLD handler
}

