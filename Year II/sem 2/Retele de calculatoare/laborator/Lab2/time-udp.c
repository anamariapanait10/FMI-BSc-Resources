#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <arpa/inet.h>
#include <time.h>

#define BUFSIZE 64
#define UNIXEPOCH 2208988800 /* UNIX epoch, in UCT secs */
#define MSG "what time is it?\n"

typedef unsigned long u_long;
extern int errno;

int connectUDP(const char *host, const char *service);

/*------------------------------------------------------------------------
* main - UDP client for TIME service that prints the resulting time
*------------------------------------------------------------------------
*/
int main(int argc, char *argv[])
{
	char *host = "localhost"; /* host to use if none supplied */
	char *service = "time";	/* default service name */
	time_t now;		/* 32-bit integer to hold time */
	int s, n;		/* socket descriptor, read count*/


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
			fprintf(stderr, "usage: UDPtime [host [port]]\n");
		exit(1);
	}
	s = connectUDP(host, service);
	(void) write(s, MSG, strlen(MSG));

	/* Read the time */
	n = read(s, (char *)&now, sizeof(now));
	if (n < 0)
		printf("read failed: %s\n", strerror(errno));
	now = ntohl((u_long)now); 	/* put in host byte order */
	now -= UNIXEPOCH; 		/* convert UCT to UNIX epoch */

	printf("%s", ctime(&now));
	exit(0);
}

