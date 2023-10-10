#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>
#include <errno.h>

int passiveTCP(const char *service, int qlen);
int passiveUDP(const char *service);
void gettime(time_t *);

#define QLEN 5
#define UNIXEPOCH 2208988800 /* UNIX epoch, in UCT secs */

/*------------------------------------------------------------------------
* main - Iterative TCP server for DAYTIME service
*------------------------------------------------------------------------
*/
int main(int argc, char *argv[])
{
	struct sockaddr_in fsin; /* the from address of a client */
	char *service = "time"; /* service name or port number */
	int tsock, usock, ssock; /* master & slave sockets */
	int alen; /* from-address length */
	fd_set rfds; /* read file descriptor set */
	fd_set afds; /* active file descriptor set */
	int fd, nfds;
	char buf[128]; /* "input" buffer; any size > 0 */
	time_t now;

	switch (argc) {
		case 1:
			break;
		case 2:
			service = argv[1];
			break;
		default:
			printf("usage: TCPdaytimed [port]\n"), exit(1);
	}

	// create passive TCP socket
	// create passive UDP socket
	// find out the size of the file descriptor table
	

	// zero your file descriptor set(s)
	// add file descriptor(s) to your zeroed file descriptor ste(s)
	
	while (1) {

		// add the file descriptors of interest to the appropriate file descriptor set

		if (select(..., ..., ..., ..., (struct timeval *)0) < 0)
			printf("select failed: %s\n", strerror(errno)), exit(1);

		// check if the passive UDP socket is ready for use
		// if so
			// handle the UDP client request as in previous labs 
		
		// else if the passive TCP socket is ready for use
			// handle the TCP client request as in previous labs
			// do not forget to close the newly created socket !
		
	}
}

void gettime(time_t *now)
{
	// get the current time
}

