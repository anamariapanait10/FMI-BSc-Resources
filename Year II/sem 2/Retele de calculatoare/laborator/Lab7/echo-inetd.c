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
	char *service = "echo"; /* service name or port number */
	char buf[4096];
	int cc;

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

	syslog(LOG_USER|LOG_NOTICE,"starting echo service on port %d\n", atoi(argv[1]));

	
	while (cc = read(0, buf, sizeof buf)) {
		if (cc < 0)
			syslog(LOG_USER|LOG_NOTICE,"echo read error: %m\n"), exit(1);
		if (write(1, buf, cc) < 0)
			syslog(LOG_USER|LOG_NOTICE,"echo write error: %m\n"), exit(1);
	}

	close(0);
	close(1);
	exit(0);
}



