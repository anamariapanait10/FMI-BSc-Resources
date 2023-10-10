#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <time.h>
#include <syslog.h>

#define UNIXEPOCH 2208988800 /* UNIX epoch, in UCT secs */

/*------------------------------------------------------------------------
* main - Iterative TCP server for DAYTIME service
*------------------------------------------------------------------------
*/
int main(int argc, char *argv[])
{
	struct sockaddr_in fsin; /* the from address of a client */
	char *service = "time"; /* service name or port number */
	time_t now;

	openlog(argv[0], LOG_PID, 0);	

	switch (argc) {
		case 1:
			break;
		case 2:
			service = argv[1];
			break;
		default:
			syslog(LOG_USER|LOG_NOTICE,"usage: %s [port]\n", argv[0]);
			exit(1);
	}

	syslog(LOG_USER|LOG_NOTICE,"starting time service on port %d\n", atoi(argv[1]));

	time(&now);
	now = htonl((u_long)(now + UNIXEPOCH));
	write(1, (char*)&now, sizeof(now));

	close(0);
	close(1);
	exit(0);
}



