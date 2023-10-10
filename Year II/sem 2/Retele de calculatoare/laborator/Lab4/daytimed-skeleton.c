#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>
#include <errno.h>

int TCPdaytimed(int fd);
int passiveTCP(const char *service, int qlen);

#define QLEN 5

/*------------------------------------------------------------------------
* main - Iterative TCP server for DAYTIME service
*------------------------------------------------------------------------
*/
int main(int argc, char *argv[])
{
	struct sockaddr_in fsin; /* the from address of a client */
	char *service = "daytime"; /* service name or port number */
	int msock, ssock; /* master & slave sockets */
	int alen; /* from-address length */
	fd_set rfds; /* read file descriptor set */
	fd_set wfds; /* write file descriptor set */
	fd_set afds; /* active file descriptor set */
	int fd, nfds;


	switch (argc) {
		case 1:
			break;
		case 2:
			service = argv[1];
			break;
		default:
			printf("usage: TCPdaytimed [port]\n"), exit(1);
	}

	// create passive socket
	// find the size of the file descriptor table, man getdtablesize
	
	// zero the file descriptor set(s) you want to use
	// add descriptor(s) to the zeroed file descriptor set(s)

	while (1) {

		// make sure your file descriptor sets are properly set
	
		if (select(..., ..., ..., ..., (struct timeval *)0) < 0)
			printf("select failed: %s\n", strerror(errno)), exit(1);

		// check if passive sock file descriptor is ready to accept new connection requests
		// if so
			// accept the new connection request
			// add the newly created socket to the appropriate file descriptor set
				
		// loop over the file descriptor set to check for file descriptors ready for use
			// check if a particular file descriptor (NOT the passive socket!) is ready for use
			// if so
				// handle the request received over the socket represented by that file descriptor
				// close the file descriptor and clear it from the file descriptor set(s) you used
		
	}
}

int TCPdaytimed(int fd)
{
	char *pts; /* pointer to time string */
	time_t now; /* current time */
	char *ctime();

	// for problem 3 add code here
	(void) time(&now);
	pts = ctime(&now);
	(void) write(fd, pts, strlen(pts));
	return 0;
}


