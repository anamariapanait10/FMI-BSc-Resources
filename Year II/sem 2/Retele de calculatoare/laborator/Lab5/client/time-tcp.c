#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <time.h>
#include <arpa/inet.h>

void TCPdaytime(const char *host, const char *service);
int connectTCP(const char *host, const char *service);

#define LINELEN	128
#define UNIXEPOCH 2208988800 /* UNIX epoch, in UCT secs */

/*------------------------------------------------------------------------
* main - TCP client for DAYTIME service
*------------------------------------------------------------------------
*/

int main(int argc, char *argv[])
{
	char *host = "localhost"; /* host to use if none supplied */
	char *service = "daytime"; /* default service port */

	switch (argc) {
		case 1:
			host = "localhost";
			break;
		case 3:
			service = argv[2];
			/* FALL THROUGH */
		case 2:
			host = argv[1];
			break;
		default:
			fprintf(stderr, "usage: TCPdaytime [host [port]]\n");
			exit(1);
	}

	TCPdaytime(host, service);
	exit(0);
}

/*------------------------------------------------------------------------
* TCPdaytime - invoke Daytime on specified host and print results
*------------------------------------------------------------------------
*/

void TCPdaytime(const char *host, const char *service)
{
	char buf[LINELEN+1];	 /* buffer for one line of text */
	int s, n;		/* socket, read count */
	time_t now;

	s = connectTCP(host, service);
	n = read(s, (char *)&now, sizeof(now));
	if (n < 0)
		printf("read failed: %s\n", strerror(errno));
	now = ntohl((u_long)now); 	/* put in host byte order */
	now -= UNIXEPOCH; 		/* convert UCT to UNIX epoch */

	printf("%s", ctime(&now));
}
