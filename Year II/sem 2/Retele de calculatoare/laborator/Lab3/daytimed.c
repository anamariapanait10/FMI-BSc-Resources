#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
extern int

int errno;
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


	switch (argc) {
		case 1:
			break;
		case 2:
			service = argv[1];
			break;
		default:
			printf("usage: TCPdaytimed [port]\n"), exit(1);
	}

	msock = passiveTCP(service, QLEN);

	while (1) {
		ssock = accept(msock, (struct sockaddr *)&fsin, &alen);
		if (ssock < 0)
			printf("accept failed: %s\n", strerror(errno)), exit(1);
		(void) TCPdaytimed(ssock);
		(void) close(ssock);
	}
}

int TCPdaytimed(int fd)
{
	char *pts; /* pointer to time string */
	time_t now; /* current time */
	char *ctime();


	(void) time(&now);
	pts = ctime(&now);
	(void) write(fd, pts, strlen(pts));
	return 0;
}


