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

	msock = passiveTCP(service, QLEN);
	nfds = getdtablesize();

	FD_ZERO(&afds);
	FD_SET(msock, &afds);

	while (1) {

		memcpy(&rfds, &afds, sizeof(rfds));
		memcpy(&wfds, &afds, sizeof(wfds));

		if (select(nfds, &rfds, &wfds, (fd_set *)0, (struct timeval *)0) < 0)
			printf("select failed: %s\n", strerror(errno)), exit(1);

		
		if (FD_ISSET(msock, &rfds)) 
		{
			int ssock;

			alen = sizeof(fsin);
			ssock = accept(msock, (struct sockaddr *)&fsin, &alen);
			if (ssock < 0)
				printf("accept failed: %s\n", strerror(errno)), exit(1);
			FD_SET(ssock, &afds);
		}
		

		for (fd=0; fd<nfds; ++fd)
			if (fd != msock && FD_ISSET(fd, &wfds))
				if (TCPdaytimed(fd) == 0) 
				{
					(void) close(fd);
					FD_CLR(fd, &afds);
				}
	}
}

int TCPdaytimed(int fd)
{
	char *pts; /* pointer to time string */
	time_t now; /* current time */
	char *ctime();

/* needed for the PID-based protocol version */
/*
	int n;
	char buf[128];

	n = read(fd, buf, sizeof(buf));
	printf("%s\n", buf);
	write(fd, buf, n);
*/
	(void) time(&now);
	pts = ctime(&now);
	(void) write(fd, pts, strlen(pts));
	return 0;
}


