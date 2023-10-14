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

/*------------------------------------------------------------------------
* main - Iterative TCP server for DAYTIME service
*------------------------------------------------------------------------
*/
int main(int argc, char *argv[])
{
	struct sockaddr_in fsin; /* the from address of a client */
	char *service = "daytime"; /* service name or port number */
	time_t now;
	char *pts;

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

	syslog(LOG_USER|LOG_NOTICE,"starting daytime service on port %d\n", atoi(argv[1]));

	(void) time(&now);
	pts = ctime(&now);
	(void) write(1, pts, strlen(pts));

	close(1);
	exit(0);
}



