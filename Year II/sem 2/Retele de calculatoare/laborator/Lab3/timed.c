
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <time.h>
#include <string.h>

typedef unsigned long u_long;
extern int errno;
int passiveUDP(const char *service);
#define UNIXEPOCH 2208988800 /* UNIX epoch, in UCT secs */

/*------------------------------------------------------------------------
* main - Iterative UDP server for TIME service
*------------------------------------------------------------------------
*/
int main(int argc, char *argv[])
{
	struct sockaddr_in fsin; /* the from address of a client */
	char *service = "time"; /* service name or port number */
	char buf[1]; /* "input" buffer; any size > 0 */
	int sock; /* server socket */
	time_t now; /* current time */
	int alen; /* from-address length */

	switch (argc) {
		case 1:
			break;
		case 2:
			service = argv[1];
			break;
		default:
			printf("usage: UDPtimed [port]\n"), exit(1);
	}

	sock = passiveUDP(service);

	while (1) {
		alen = sizeof(fsin);
		if (recvfrom(sock, buf, sizeof(buf), 0, (struct sockaddr *)&fsin, &alen) < 0)
			printf("recvfrom: %s\n", strerror(errno)), exit(1);
		(void) time(&now);
		now = htonl((u_long)(now + UNIXEPOCH));
		(void) sendto(sock, (char *)&now, sizeof(now), 0, (struct sockaddr *)&fsin, sizeof(fsin));
	}
}

