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

	tsock = passiveTCP(service, QLEN);
	usock = passiveUDP(service);
	nfds = getdtablesize();

	FD_ZERO(&afds);
	FD_SET(tsock, &afds);
	FD_SET(usock, &afds);

	while (1) {

		memcpy(&rfds, &afds, sizeof(rfds));

		if (select(nfds, &rfds, (fd_set *)0, (fd_set *)0, (struct timeval *)0) < 0)
			printf("select failed: %s\n", strerror(errno)), exit(1);

		
		if (FD_ISSET(usock, &rfds)) 
		{
			alen = sizeof(fsin);
			if (recvfrom(usock, buf, sizeof(buf), 0, (struct sockaddr *)&fsin, &alen) < 0)
							printf("recvfrom: %s\n", strerror(errno)), exit(1);
			gettime(&now);
			sendto(usock, (char *)&now, sizeof(now), 0, (struct sockaddr *)&fsin, sizeof(fsin));
		}
		else if (FD_ISSET(tsock, &rfds)) 
		{
			int ssock;

			alen = sizeof(fsin);
			ssock = accept(tsock, (struct sockaddr *)&fsin, &alen);
			if (ssock < 0)
				printf("accept failed: %s\n", strerror(errno)), exit(1);

			gettime(&now);
			write(ssock, (char*)&now, sizeof(now));
			close(ssock);
		}
	}
}

void gettime(time_t *now)
{
	time(now);
	*now = htonl((u_long)(*now + UNIXEPOCH));
}

